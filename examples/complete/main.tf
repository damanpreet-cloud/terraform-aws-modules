terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type    = string
  default = "ca-central-1"
}

variable "cluster_name" {
  type    = string
  default = "demo"
}

variable "admin_cidrs" {
  description = "Your public IP as a /32 to reach the API server. Leave empty for a private-only endpoint."
  type        = list(string)
  default     = []
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = var.cluster_name
  cidr_block           = "10.0.0.0/16"
  azs                  = local.azs
  public_subnet_cidrs  = [for i in range(3) : cidrsubnet("10.0.0.0/16", 8, i)]
  private_subnet_cidrs = [for i in range(3) : cidrsubnet("10.0.0.0/16", 8, i + 10)]
  single_nat_gateway   = true
  enable_flow_logs     = true
  eks_cluster_name     = var.cluster_name
}

module "eks" {
  source = "../../modules/eks"

  cluster_name           = var.cluster_name
  subnet_ids             = module.vpc.private_subnet_ids
  endpoint_public_access = length(var.admin_cidrs) > 0
  public_access_cidrs    = var.admin_cidrs

  node_groups = {
    general = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}

module "lambda_role" {
  source = "../../modules/iam-service-role"

  name             = "${var.cluster_name}-example-lambda"
  trusted_services = ["lambda.amazonaws.com"]
  policy_arns      = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
