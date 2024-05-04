
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # profile = "default"
}

import {
  to = aws_security_group.mysg
  id = "sg-08db8b0794bba30f1tf"
}
