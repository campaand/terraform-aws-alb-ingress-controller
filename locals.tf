# Created by Andrea Campice

locals {
  oidc_provider = replace(data.aws_eks_cluster.this[0].identity[0].oidc[0].issuer, "https://", "")
}