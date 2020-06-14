
provider "aws" {
  region = var.region
}

resource "aws_key_pair" "instance-key-pair" {
  key_name   = var.amazon_instance.keypair.private
  public_key = "${file("${ var.amazon_instance.keypair.public }")}"
}

resource "aws_instance" "master1_centos" {
  ami           = "ami-0ff750889570c0406"
  key_name = aws_key_pair.instance-key-pair.key_name
  instance_type = var.amazon_instance.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  tags          = { Name = var.amazon_instance.name }

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
