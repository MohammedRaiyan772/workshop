terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1" # Configuration options
}
terraform {
  backend "s3" {
    bucket = "raiyan1"
    key = "dev/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}