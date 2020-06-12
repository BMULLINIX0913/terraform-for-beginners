provider "aws" {
  region = "us-east-2"
}
resource "aws_instance" "master1_centos" {
  ami           = "ami-3c715059"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.instance.id]
  tags          = { Name = "master" }

}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



