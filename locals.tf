# Created by Andrea Campice

locals {
  controller_iam_role_name = var.suffix != "" ? "${var.controller_iam_role_name}-${title(var.suffix)}" : "${var.controller_iam_role_name}"
  oidc_provider            = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
  helm_values = merge(local.default_helm_values, var.settings)

  default_helm_values = var.use_eks_pod_identity ? {
    "clusterName"         = "${var.cluster_name}",
    "serviceAccount.name" = "${var.service_account_name}",
  } : {
    "clusterName"         = "${var.cluster_name}",
    "serviceAccount.name" = "${var.service_account_name}",

    "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = "${aws_iam_role.this[0].arn}"
  }
}