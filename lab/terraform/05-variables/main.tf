

resource "aws_security_group" "ejemplo" {
  name = "my-tf-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allow_ips]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ips]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allow_ips]
  }
}


resource "aws_instance" "myec2" {
  ami                    = "ami-07caf09b362be10b8" #Imagen del SO amazon
  instance_type          = "t2.micro"
  key_name               = "devops-udi-2024"
  vpc_security_group_ids = [aws_security_group.ejemplo.id]
  tags = {
    Name = "tf-rapaza"
  }
}
