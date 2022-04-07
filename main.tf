# Created by Andrea Campice

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_policy" "this" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "AWS Load Balancer Controller Policy"
  policy      = file("${path.module}/load-balancer-controller-policy.json")
}

resource "aws_iam_role" "this" {
  name               = "AWSEKSLoadBalancerControllerRole"
  description        = "AWS EKS Load Balancer Controller Role"
  assume_role_policy = templatefile("${path.module}/load-balancer-role-trust-policy.tftpl", { "customer_account_id" = "${data.aws_caller_identity.current.account_id}", "oidc_provider" = "${var.oidc_provider}", "namespace" = "${var.namespace}" })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "kubernetes_namespace_v1" "this" {
  count = var.namespace != "kube-system" ? 1 : 0
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_manifest" "this" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ServiceAccount"
    "metadata" = {
      "annotations" = {
        "eks.amazonaws.com/role-arn" = "${aws_iam_role.this.arn}"
      }
      "labels" = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      }
      "name"      = "aws-load-balancer-controller"
      "namespace" = "${var.namespace}"
    }
  }
  depends_on = [
    kubernetes_namespace_v1.this
  ]
}

resource "helm_release" "alb_ingress_controller" {
  chart            = "aws-load-balancer-controller"
  create_namespace = true
  namespace        = var.namespace
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  version          = var.helm_chart_version
  cleanup_on_fail  = true
  recreate_pods    = true
  replace          = true
  set {
    name  = "image.repository"
    value = "docker.io/amazon/aws-alb-ingress-controller"
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [
    kubernetes_manifest.this
  ]
}