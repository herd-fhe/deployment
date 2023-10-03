terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }

    template = {
      source = "hashicorp/template"
      version= "~> 2.0"
    }

    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.25.0"
    }
  }
}