# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

# 1.0.0 - (23 April 2023) - First Official Version

## Major Changes
* Now `helm_chart_version` use always the latest version of the chart, you can overwrite it
* Removed unused `vpc_id` variable
* Removed the following resources:
    - `kubernetes_manifest.this`
    - `kubernetes_namespace_v1.this`: the namespace will be created direcly by Helm Chart if does not exists
    - `aws_iam_role_policy_attachment.this`: the attachment will be done directly with `aws_iam_role_policy.this` resource
* Modified required versions for kubernetes and helm providers (will use always the latest version for major 2.0)
* Added `controller_iam_role_name` variable to overwrite the default IAM Role Name for Controller
* Removed `image.repository` helm chart values from local map `default_helm_values` now the chart will use the default repository
* Removed `serviceAccount.create` helm chart values from local map `default_helm_values` now the chart will create the service account using the helm chart
* Added IAM role arn annotations for Service Account

# 0.3.0 - (10 May 2022)

## Changes
* Added possibility to overwrite the default values ​​for the chart helm
* Added `default_helm_values` local and `helm_values` local with merged default and custom settings
* Added `service_account_name` variable to customize service account name
* Added service account name variable for .tftpl template file

# 0.2.1 - (08 April 2022)

## Bug Fix
* Fixed `oidc_provider` local

## Note
* Added 2048 game to test ALB Controller

# 0.2.0 - (07 April 2022)

## Changes
* Added `data/aws_eks_cluster.this` to get dynamically oidc provider
* Added `locals.tf` file to manage oidc provider without https:// prefix
* Removed `oidc_provider` variable

## Note
* Added descriptions for variables

# 0.1.0 - (07 April 2022)

## Major Changes
* Test terraform module release