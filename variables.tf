# Created by Andrea Campice

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name/ID"
}

variable "suffix" {
  type        = string
  description = "Suffix to add to resource names"
  default     = ""
  validation {
    condition     = can(regex("^[A-Za-z0-9]*$", var.suffix))
    error_message = "The suffix must not contains special characters."
  }
}

variable "helm_chart_values" {
  type        = list(string)
  default     = []
  description = "Values List of String or Values File in yaml format"
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

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace where ALB Controller will be created"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller#configuration"
}

variable "use_eks_pod_identity" {
  type        = bool
  default     = false
  description = "If true, AWS Load Balancer controller will use EKS POD IDENTITY, can only used with AWS Controller >= v2.7.0"
}

variable "controller_iam_role_name" {
  type        = string
  default     = "IRSA-EKSLoadBalancerControllerRole"
  description = "IAM Role Name for ALB Controller"
}

variable "custom_eks_pod_identity_iam_role_arn" {
  type        = string
  default     = ""
  description = "Existing IAM Role ARN that you want to use for EKS POD IDENTITY Authentication, must be properly configured"
  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.custom_eks_pod_identity_iam_role_arn)) || var.custom_eks_pod_identity_iam_role_arn == ""
    error_message = "The value must be a valid AWS IAM role ARN"
  }
}