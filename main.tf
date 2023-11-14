data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  count = var.base_domain == null ? 0 : 1

  name = var.base_domain
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_name
}

module "cluster" {
  source = "terraform-aws-modules/eks/aws"

  version = "~> 18"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  vpc_id      = var.vpc_id
  subnet_ids  = var.private_subnet_ids
  enable_irsa = true

  create_aws_auth_configmap = var.use_self_managed_node_groups
  manage_aws_auth_configmap = true

  aws_auth_accounts = var.aws_auth_accounts
  aws_auth_roles    = var.aws_auth_roles
  aws_auth_users    = var.aws_auth_users

  eks_managed_node_groups  = { for k, v in var.node_groups : k => v if !var.use_self_managed_node_groups }
  self_managed_node_groups = { for k, v in var.node_groups : k => v if var.use_self_managed_node_groups }

  self_managed_node_group_defaults = {
    create_security_group = false
  }
  eks_managed_node_group_defaults = {
    create_security_group = false
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_all_http = {
      description      = "Node HTTP ingress"
      protocol         = "tcp"
      from_port        = 80
      to_port          = 80
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_all_https = {
      description      = "Node HTTPS ingress"
      protocol         = "tcp"
      from_port        = 443
      to_port          = 443
      type             = "ingress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}
