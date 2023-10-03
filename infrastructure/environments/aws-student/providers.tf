provider "aws" {
  region = var.aws_default_region

  default_tags {
    tags = {
      Project = "fhe-serverless"
    }
  }
}