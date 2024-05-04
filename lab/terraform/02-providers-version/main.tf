
resource "aws_instance" "myec2" {
  ami           = "ami-07caf09b362be10b8" #Imagen del SO amazon
  instance_type = "t2.micro"
  key_name      = "devops-udi-2024"
  tags = {
    Name = "tf-rapaza"
  }
}