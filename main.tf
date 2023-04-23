# Created by Andrea Campice

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster" "this" { name = var.cluster_name }

resource "aws_iam_role" "this" {
  name               = var.controller_iam_role_name
  description        = "AWS EKS Load Balancer Controller Role"
  assume_role_policy = templatefile("${path.module}/load-balancer-role-trust-policy.tftpl", { "account_id" = "${data.aws_caller_identity.current.account_id}", "oidc_provider" = "${local.oidc_provider}", "namespace" = "${var.namespace}", "service_account_name" = "${var.service_account_name}" })
}

resource "aws_iam_role_policy" "this" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  role   = aws_iam_role.this.arn
  policy = file("${path.module}/load-balancer-controller-policy.json")
}

resource "helm_release" "alb_ingress_controller" {
  chart            = "aws-load-balancer-controller"
  create_namespace = var.namespace != "kube-system" ? true : false
  namespace        = var.namespace
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  version          = var.helm_chart_version
  cleanup_on_fail  = true
  recreate_pods    = true
  replace          = true
  dynamic "set" {
    for_each = local.helm_values
    content {
      name  = set.key
      value = set.value
    }
  }
}