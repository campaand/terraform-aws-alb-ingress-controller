# Terraform module: AWS ALB Ingress Controller

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
  version = "~> 1.0"

  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
}
```

### EKS Deployment with Different Namespace

To deploy the AWS ALB Ingress Controller into an EKS cluster using different custom namespace, if not exist, the namespace will be created.

```hcl
module "alb_controller" {
  source  = "campaand/alb-controller/aws"
  version = "~> 1.0"

  namespace    = "your-custom-namespace"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
}
```

### EKS Deployment with Different Helm Settings

To deploy the AWS ALB Ingress Controller into an EKS cluster using different helm parameters based on [Helm Chart Values](https://github.com/kubernetes-sigs/aws-alb-ingress-controller).

If you need to insert custom annotations for Ingresses and Services, consult [ALB Controller Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/).

Helm Values already setted:

```hcl
default_helm_values = {
  "image.repository" = "docker.io/amazon/aws-alb-ingress-controller", 
  "clusterName" = "${var.cluster_name}",
  "serviceAccount.create" = "false",
  "serviceAccount.name" = "${var.service_account_name}"
}
```

You can add or overwrite this values using the settings variable, if you add a value with the same key, you overwrote the default one.

```hcl
module "alb_controller" {
  source  = "campaand/alb-controller/aws"
  version = "~> 1.0"

  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  
  helm_chart_version = "1.4.6"

  settings = {
      key1 = value1,
      key2 = value2,
      key3 = value3,
      key4 = value4
  }
}
```

## Test your infrastructure

https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html#application-load-balancer-sample-application