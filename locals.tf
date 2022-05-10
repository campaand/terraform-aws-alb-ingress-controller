# Created by Andrea Campice

locals {
  oidc_provider = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
  default_helm_values = {
    "image.repository" = "docker.io/amazon/aws-alb-ingress-controller",
    "clusterName" = "${var.cluster_name}",
    "serviceAccount.create" = "false",
    "serviceAccount.name" = "${var.service_account_name}"
  }
  helm_values = merge(local.default_helm_values, var.settings)
}