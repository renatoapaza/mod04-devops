terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = "us-east-1" # Verificar la region
}


resource "aws_instance" "jenkins" {
  ami                         = "ami-0bb84b8ffd87024d8" # Verificar el id SO 
  instance_type               = "t2.micro"
  key_name                    = "devops-udi-2024" # Key Pair deben crear uno con ese nombre o utilizar el que ya tienen creado
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  //user_data                   = file("install_jenkins.sh")


  tags = {
    Name = "Jenkins-Server"
  }
}


resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow Port 22 and 8080"

  ingress {
    description = "Allow SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 8080 Traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "my-s3-bucket" {
  bucket = "jenkins-s3-bucket-rapaza" # Cambiar el nombre del s3, recodar que debe ser unico a nivel global.

  tags = {
    Name = "Jenkins-Server"
  }
}


resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket     = aws_s3_bucket.my-s3-bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}


resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.my-s3-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

# Ansible
# Ejecuta el playbook denominado "install-jenkins.yaml", con el inventario creado de manera automatica 
# con el nombre "ansible_inventory"
# con la IP del EC2, posterior a ello lo elimina.
# El usuario de comexion es "ec2-user" puesto que nuestro SO es un linux de AWS
# adicional, se especifica el Key Pair creado con anterioridad "devops-udi-2024.pem".
resource "null_resource" "ansible_provisioner" {
  depends_on = [aws_instance.jenkins]

  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 wait instance-running --instance-ids "${aws_instance.jenkins.id}" 
      echo "[jenkins-server]" > ansible_inventory
      echo "${aws_instance.jenkins.public_ip}" >> ansible_inventory
      ansible-playbook -i ansible_inventory install-jenkins.yaml -u ec2-user --private-key devops-udi-2024.pem
      rm ansible_inventory
    EOT
  }
}