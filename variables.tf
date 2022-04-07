# Created by Andrea Campice

variable "oidc_provider" {
  type        = string
  description = "Additional settings which will be passed to the Helm chart values"
}

variable "vpc_id" {
  type        = string
  description = "Additional settings which will be passed to the Helm chart values"
}

variable "cluster_name" {
  type        = string
  description = "Additional settings which will be passed to the Helm chart values"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "helm_chart_version" {
  type        = string
  default     = "1.4.1"
  description = "Version for Helm Chart, not Application Version, https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
}