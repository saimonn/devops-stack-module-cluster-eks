locals {
  base_domain = coalesce(var.base_domain, format("%s.nip.io", replace(data.dns_a_record_set.nlb.addrs[0], ".", "-")))

  # TODO Review the need for these locals. They were commented on the last version and I'll leave them commented for now.
  # target_group_arns = concat(module.nlb.target_group_arns, module.nlb_private.target_group_arns)
  # target_groups_node_groups = { for group in var.nlb_attached_node_groups : group => { target_group_arns = local.target_group_arns } }
}

# TODO Review the need for the helm_values local below.
# I think this is a remnant of the monolithic DevOps Stack and was used when deploying the cluster autoscaler chart
# on the cluster. We did not port this feature yet to the modular DevOps Stack. I'll leave the code commented for now.
/*
locals {
  helm_values = var.enable_cluster_autoscaler ? {
    cluster-autoscaler = {
      awsRegion = data.aws_region.current.name
      rbac = {
        create = true
        serviceAccount = {
          name = "cluster-autoscaler"
          annotations = {
            "eks.amazonaws.com/role-arn" = var.cluster_autoscaler_role_arn
          }
        }
      }
      autoDiscovery = {
        clusterName = var.cluster_name
        enabled = true
      }
    }
  } : {}
}
*/
