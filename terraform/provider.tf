provider "aws" {
  region = var.aws_region
  profile = "abdo"
}

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "6.43.0"
#     }
#   }
# }