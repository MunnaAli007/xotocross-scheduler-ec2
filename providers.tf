terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.23.1"
    }
  }
  
  backend "s3" {
    bucket = "xotocross_bucket_name"
    key = "state/terraform.tfstate"
    region = "eu-west-3"
  }
}

provider "aws" {
  region	= "eu-west-3"
}