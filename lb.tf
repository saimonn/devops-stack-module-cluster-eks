locals {
  nlb_name_prefix = substr(var.cluster_name, 0, 5)

  lb_target_groups_default = [
    {
      name_prefix      = local.nlb_name_prefix
      backend_protocol = "TCP"
      backend_port     = 443
      target_type      = "instance"
    },
    {
      name_prefix      = local.nlb_name_prefix
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
    },
  ]

  lb_target_groups = concat(local.lb_target_groups_default, var.extra_lb_target_groups)

  lb_http_tcp_listeners_default = [
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 1
    },
  ]
  lb_http_tcp_listeners = concat(local.lb_http_tcp_listeners_default, var.extra_lb_http_tcp_listeners)
}

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  create_lb = var.create_public_nlb

  name = var.cluster_name

  load_balancer_type = "network"

  vpc_id                           = var.vpc_id
  subnets                          = var.public_subnet_ids
  enable_cross_zone_load_balancing = true

  target_groups      = local.lb_target_groups
  http_tcp_listeners = local.lb_http_tcp_listeners
}

module "nlb_private" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  create_lb = var.create_private_nlb

  name = "${var.cluster_name}-private"

  load_balancer_type = "network"

  vpc_id                           = var.vpc_id
  subnets                          = var.private_subnet_ids
  enable_cross_zone_load_balancing = true
  internal                         = true

  target_groups      = local.lb_target_groups
  http_tcp_listeners = local.lb_http_tcp_listeners
}

resource "aws_route53_record" "wildcard" {
  count = var.base_domain != null && (var.create_public_nlb || var.create_private_nlb) ? 1 : 0

  zone_id = data.aws_route53_zone.this.0.id
  name    = format("*.apps.%s", var.cluster_name)
  type    = "CNAME"
  ttl     = "300"
  records = [
    var.create_public_nlb ? module.nlb.lb_dns_name : module.nlb_private.lb_dns_name,
  ]
}

data "dns_a_record_set" "nlb" {
  count = var.create_public_nlb ? 1 : 0
  host  = module.nlb.lb_dns_name
}

data "dns_a_record_set" "nlb_private" {
  count = var.create_private_nlb ? 1 : 0
  host  = module.nlb_private.lb_dns_name
}


locals {
  # List of node groups names from the module configuration which have "nlbs_attachment = true"
  node_groups = [for name, values in var.node_groups : name if lookup(values, "nlbs_attachment", false)]

  # Map of "public" and/or "private" NLBs with their respective target group ARNs
  nlbs_target_groups = merge(
    var.create_public_nlb ? { "public" = module.nlb.target_group_arns } : {},
    var.create_private_nlb ? { "private" = module.nlb_private.target_group_arns } : {},
  )

  # Map of all autoscaling groups created by EKS managed or self-managed node groups, referenced by the node group name
  eks_managed_autoscaling_groups_by_node_group  = { for item in setproduct(local.node_groups, module.cluster.eks_managed_node_groups_autoscaling_group_names) : item[0] => item[1] if startswith(item[1], "eks-${item[0]}") }
  self_managed_autoscaling_groups_by_node_group = { for item in setproduct(local.node_groups, module.cluster.self_managed_node_groups_autoscaling_group_names) : item[0] => item[1] if startswith(item[1], item[0]) }
  autoscaling_groups_by_node_group              = merge(local.eks_managed_autoscaling_groups_by_node_group, local.self_managed_autoscaling_groups_by_node_group)

  # Map of all autoscaling groups to target groups attachments, with unique keys based only on data from module variables suitable for use in a for_each
  autoscaling_attachments = { for item in setproduct(local.node_groups, keys(local.nlbs_target_groups), range(length(local.lb_target_groups))) : "${item[0]}_${item[1]}_${local.lb_target_groups[item[2]].backend_port}" => { "autoscaling_group" = local.autoscaling_groups_by_node_group[item[0]], "target_group_arn" = local.nlbs_target_groups[item[1]][item[2]] } }
}

resource "aws_autoscaling_attachment" "node_groups_to_nlbs_target_groups" {
  for_each = local.autoscaling_attachments

  autoscaling_group_name = each.value.autoscaling_group
  lb_target_group_arn    = each.value.target_group_arn
}
