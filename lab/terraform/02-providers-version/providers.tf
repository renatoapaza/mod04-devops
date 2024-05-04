
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
      #version = "<4.0" #Menor a la version 4.0
    }
  }
  #required_version = "1.3.8"
}

provider "aws" {
  region = "us-east-1"
  # profile = "default"
}