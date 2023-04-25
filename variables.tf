variable "cluster_name" {
  description = "Name of the EKS cluster. Must be unique in the AWS account."
  type        = string
}

variable "base_domain" {
  description = <<-EOT
    The base domain for the cluster.

    This module needs a Route 53 zone matching this variable with permission to create DNS records. It will create a wildcard CNAME record `*.apps.<base_domain>` that points to an Elastic Load Balancer routing ingress traffic to all cluster nodes. Such urls will be used by default by other DevOps Stack modules for the applications they deploy (e.g. Argo CD, Prometheus, etc).
  EOT
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = <<-EOT
    Kubernetes version for the EKS cluster.

    Please check the https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html[AWS EKS documentation] to find the available versions.

    This variable can be changed on an existing cluster to update it. *Note that this triggers an "instance refresh" on the nodes' auto scaling group, and so will recreate all pods running on the cluster*.
  EOT
  type        = string
  default     = "1.25"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster and nodes will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of IDs of private subnets that the EKS instances will be attached to."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of IDs of public subnets the public NLB will be attached to if enabled with 'create_public_nlb'."
  type        = list(string)
  default     = []
}

variable "aws_auth_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default     = []
}

variable "aws_auth_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "aws_auth_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "node_groups" {
  description = "A map of node group configurations to be created."
  type        = any
  default     = {}
}

variable "create_public_nlb" {
  description = "Whether to create an internet-facing NLB attached to the public subnets"
  type        = bool
  default     = true
}

variable "create_private_nlb" {
  description = "Whether to create an internal NLB attached the private subnets"
  type        = bool
  default     = false
}

variable "nlb_attached_node_groups" {
  description = "List of node_groups indexes that the NLB(s) should be attached to"
  type        = list(any)
  default     = []
}

variable "extra_lb_target_groups" {
  description = <<-EOT
    Additional Target Groups to attach to Network LBs.

    A list of maps containing key/value pairs that define the target groups. Required key/values: `name`, `backend_protocol`, `backend_port`.
  EOT
  type        = list(any)
  default     = []
}

variable "extra_lb_http_tcp_listeners" {
  description = <<-EOT
    Additional Listeners to attach to Network LBs.

    A list of maps describing the HTTP listeners. Required key/values: `port`, `protocol`. Optional key/values: `target_group_index` (defaults to `http_tcp_listeners[count.index]`).
  EOT
  type        = list(any)
  default     = []
}
