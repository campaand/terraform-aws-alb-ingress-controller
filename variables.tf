# Created by Andrea Campice

variable "suffix" {
  type        = string
  description = "Suffix to add to resource names"
  default     = ""
  validation {
    condition     = can(regex("^[A-Za-z0-9]*$", var.suffix))
    error_message = "The suffix must not contains special characters."
  }
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

variable "controller_iam_role_name" {
  type        = string
  default     = "AWSEKSLoadBalancerControllerRole"
  description = "IAM Role Name for ALB Controller"
}

variable "service_account_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Service Account Name for ALB Controller"
}

variable "helm_chart_version" {
  type        = string
  default     = ""
  description = "Version for Helm Chart, not Application Version, https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
}