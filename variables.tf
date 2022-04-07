# Created by Andrea Campice

variable "vpc_id" {
  type        = string
  description = "EKS Cluster VPC ID"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name / ID"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace where ALB Controller will be created"
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