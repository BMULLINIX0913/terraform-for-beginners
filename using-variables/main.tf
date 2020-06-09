
variable "region" {
      default = "us-east-2"
    }
variable "amazon_instance" {
  type = object (
    {
      name = string
      instance_type = string
    }
  )
  default = {
    name = "Instance1",
    instance_type = "t2.medium"
  }

}

provider "aws" {
  region = var.region
}
resource "aws_instance" "master1_centos" {
  ami           = "ami-3c715059"
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
}



