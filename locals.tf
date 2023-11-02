locals {
  nlb_ip = var.create_public_nlb ? data.dns_a_record_set.nlb[0].addrs[0] : (var.create_private_nlb ? data.dns_a_record_set.nlb_private[0].addrs[0] : "null")

  base_domain = coalesce(var.base_domain, format("%s.nip.io", replace(local.nlb_ip, ".", "-")))
}
