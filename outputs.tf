output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = var.cluster_name
}

output "base_domain" {
  description = "The base domain for the cluster."
  value       = local.base_domain
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.cluster.cluster_oidc_issuer_url
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = module.cluster.node_security_group_id
}

output "node_groups" {
  description = "Map of attribute maps for all node groups created."
  value       = module.cluster.self_managed_node_groups
}

output "kubernetes_host" {
  description = "Endpoint for your Kubernetes API server."
  value       = module.cluster.cluster_endpoint
}

output "kubernetes_cluster_ca_certificate" {
  description = "Certificate data required to communicate with the cluster."
  value       = base64decode(module.cluster.cluster_certificate_authority_data)
}

output "kubernetes_token" {
  description = "Token to use to authenticate with the cluster."
  value       = data.aws_eks_cluster_auth.cluster.token
}

output "nlb_target_groups" {
  description = "List of ARNs of Network LBs (public and/or private if enabled)."
  value       = concat(module.nlb.target_group_arns, module.nlb_private.target_group_arns)
}

output "kubernetes" {
  description = "Kubernetes API endpoint and CA certificate as a structured value."
  value = {
    host                   = module.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.cluster.cluster_certificate_authority_data)
  }
}
