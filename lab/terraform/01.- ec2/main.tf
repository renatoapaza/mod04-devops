
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

resource "aws_instance" "myec2" {
  ami           = "ami-07caf09b362be10b8" #Imagen del SO amazon
  instance_type = "t2.micro"
  key_name      = "devops-udi-2024"
  count = 4
  tags = {
    Name = "tf-rapaza"
  }
}



resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "tf-s3-rapaza"  #debe ser nombre unico
}
