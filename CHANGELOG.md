# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## Breaking Changes

* Test terraform module release