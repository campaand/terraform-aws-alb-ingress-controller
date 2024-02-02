# AWS EKS Load Balancer Controller
This Terraform module can be used to install the [AWS ALB Ingress Controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller)
into a Kubernetes cluster.

IMPORTANT WARNING: considering that the kubernetes provider, in order to run the plan and apply, must be able to access the cluster api, it is not possible to insert the module within the same file and / or terraform configuration that creates the EKS cluster as it is not the cluster would exist.

For this reason, I recommend separating the terraform configurations and launching the one containing this module and other modules like this one at a later time. [HERE THE ISSUE DIRECTLY FROM KUBERNETES PROVIDER](https://github.com/hashicorp/terraform-provider-kubernetes-alpha/issues/199#issuecomment-832614387)

## Examples
### EKS Basic Deployment
To deploy the AWS ALB Ingress Controller into an EKS cluster.

```hcl
module "alb_controller" {
  source  = "campaand/alb-controller/aws"
  version = "~> 2.0"

  cluster_name = var.cluster_name
}
```

### EKS Deployment with Different Namespace
To deploy the AWS ALB Ingress Controller into an EKS cluster using different custom namespace, if not exist, the namespace will be created.

```hcl
module "alb_controller" {
  source  = "campaand/alb-controller/aws"
  version = "~> 2.0"

  namespace    = "your-custom-namespace"
  cluster_name = var.cluster_name
}
```

### EKS Deployment using EKS POD Identity
To deploy the AWS ALB Ingress Controller into an EKS cluster using EKS POD Identity Authentication.

NOTE: if you want to change from IRSA to POD Identity, or vice-versa, you must have the "eks-pod-identity-agent" addon installed and after applying you will have to roll out the aws-load-balancer-controller deployment.

```hcl
module "alb_controller" {
  source  = "campaand/alb-controller/aws"
  version = "~> 2.0"

  namespace    = "your-custom-namespace"
  cluster_name = var.cluster_name

  use_eks_pod_identity = true
}
```

You can also use your custom IAM Role for POD IDENTITY, but you need to properly configure with correct trusted entities and policy.

```hcl
module "alb_controller" {
  source  = "campaand/alb-controller/aws"
  version = "~> 2.0"

  namespace    = "your-custom-namespace"
  cluster_name = var.cluster_name

  use_eks_pod_identity = true
  custom_eks_pod_identity_iam_role_arn = "arn:aws:iam::01234567890:role/test-eks-identity-alb"
}
```

### EKS Deployment with Different Helm Settings
To deploy the AWS ALB Ingress Controller into an EKS cluster using different helm parameters based on [Helm Chart Values](https://github.com/kubernetes-sigs/aws-alb-ingress-controller).

If you need to insert custom annotations for Ingresses and Services, consult [ALB Controller Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/).

Helm Values already setted:

```hcl
default_helm_values = {
  "clusterName"         = "${var.cluster_name}",
  "serviceAccount.name" = "${var.service_account_name}"

  "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = "${aws_iam_role.this.arn}"
}
```

You can add or overwrite this values using the settings variable, if you add a value with the same key, you overwrote the default one.

```hcl
module "alb_controller" {
  source  = "campaand/alb-controller/aws"
  version = "~> 2.0"

  cluster_name = var.cluster_name
  
  helm_chart_version = "1.6.0"

  settings = {
      key1 = value1,
      key2 = value2,
      key3 = value3,
      key4 = value4
  }
}
```

## Test your infrastructure
Here some examples to test your ALB Controller: [Official Repository Link](https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/docs/examples)