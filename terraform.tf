terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 1"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = ">= 4"
    }
  }

  required_version = ">= 1.0"
}
