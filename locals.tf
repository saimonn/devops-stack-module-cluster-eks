locals {
  base_domain = coalesce(var.base_domain, format("%s.nip.io", replace(data.dns_a_record_set.nlb.addrs[0], ".", "-")))
}
