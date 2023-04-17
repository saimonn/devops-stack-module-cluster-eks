locals {
  base_domain = coalesce(var.base_domain, format("%s.nip.io", replace(data.dns_a_record_set.nlb.addrs[0], ".", "-")))

  # TODO Review the need for these locals. They were commented on the last version and I'll leave them commented for now.
  # target_group_arns = concat(module.nlb.target_group_arns, module.nlb_private.target_group_arns)
  # target_groups_node_groups = { for group in var.nlb_attached_node_groups : group => { target_group_arns = local.target_group_arns } }
}
