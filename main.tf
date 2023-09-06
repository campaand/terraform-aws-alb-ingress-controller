# Created by Andrea Campice

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster" "this" { name = var.cluster_name }

data "http" "alb_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${helm_release.alb_ingress_controller.metadata[0].app_version}/docs/install/iam_policy.json"
}

resource "aws_iam_role" "this" {
  name               = var.controller_iam_role_name
  description        = "AWS EKS Load Balancer Controller Role"
  assume_role_policy = templatefile("${path.module}/load-balancer-role-trust-policy.tftpl", { "account_id" = "${data.aws_caller_identity.current.account_id}", "oidc_provider" = "${local.oidc_provider}", "namespace" = "${var.namespace}", "service_account_name" = "${var.service_account_name}" })
}

resource "aws_iam_role_policy" "this" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  role   = aws_iam_role.this.id
  policy = data.http.alb_policy.response_body
}

resource "helm_release" "alb_ingress_controller" {
  chart            = "aws-load-balancer-controller"
  create_namespace = var.namespace != "kube-system" ? true : false
  namespace        = var.namespace
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  version          = var.helm_chart_version != "" ? var.helm_chart_version : ""
  cleanup_on_fail  = true
  recreate_pods    = true
  replace          = true
  values           = var.helm_chart_values
  dynamic "set" {
    for_each = local.helm_values
    content {
      name  = set.key
      value = set.value
    }
  }
}