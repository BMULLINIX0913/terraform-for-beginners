# Working with Terraform and Injecting Your SSH Key for your Amazon EC2 Instance

Last updated: 06.10.2020

## Purpose

The purpose of this document is to show how to inject a ssh key into your
new Amazon EC2 instance and then using it to login.

## Prerequisites

You must follow the [readme.md](../readme.md) steps.

## Instructions

1. export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY"
1. export AWS_SECRET_ACCESS_KEY="YOUR SECRET KEY"
1. cp ../getting_started/main.tf .
1. Generate a key pair `ssh-keygen -t rsa -f instance1`
1. chmod 400 ./instance1
1. vi main.tf
1. Add the following block to the top of the file:

    ```hcl-terraform
        variable "region" {
          default = "us-east-2"
        }
        
        variable "amazon_instance" {
          type = object (
          {
            name = string
            instance_type = string
            keypair = object(
            {
              private = string
              public = string
            })
          })
          default = {
            name = "Instance1",
            instance_type = "t2.medium"
            keypair = {
              private = "instance1"
              public = "instance1.pub"
            }
          }
        }
    ```

    The block above shows that we are declaring a string
    variable called **v_region** with a default value of
    **us-east-2** and an object variable called **amazon_instance**.
    The object variable declares three internal variables called
    **name** with a type of **string**, **instance_type** with
    a type of **string**, and **keypair** of type object.
    The internal values are given **default**
    values of **Instance1**, **t2.medium**, and **an object
    containing the ssh key** respectively.

1. Replace the provider section with the following:

    ```hcl-terraform
    provider "aws" {
      region = var.region
    }
    ```

   The provider is now using the variable **var.region** which we
   defined as the variable **region**.

1. Add the amazon key pair for the instance:

    ```hcl-terraform
     resource "aws_key_pair" "instance-key-pair" {
       key_name   = var.amazon_instance.keypair.private
       public_key = "${file("${ var.amazon_instance.keypair.public }")}"
     }
    ```
    The block above shows that we are using our object variable
    **amazon_instance**.  We are assigning the **keypair** private variable
    as the **AWS Key Pair name** and the **keypair** public_key variable
    as a parameter to load the public key pair file to use for
    the **AWS Key Pair** public_key.
   
1. Replace the resource "aws_instance" "master1_centos" section
with the following:

   ```hcl-terraform
   resource "aws_instance" "master1_centos" {
     ami           = "ami-3c715059"
     key_name = aws_key_pair.instance-key-pair.key_name
     instance_type = var.amazon_instance.instance_type
     vpc_security_group_ids = [aws_security_group.instance.id]
     tags          = { Name = var.amazon_instance.name }

   }
    ```

   The block above shows that we are using our object variable
   **amazon_instance**.  We are assigning the resource instance_type to
   the **amazon_instance.instance_type**, and the resource instance
   tag "Name" to the **amazon_instance.name**

1. Save your file
1. terraform init
1. Run `terraform plan` to find any errors and review
your deployment.
1. Run `terraform apply` to deploy your ec2 instance.
1. Wait 5 minutes
1. Run `terraform show` | grep ec2-

    The output of the previous step is your public url to the ec2 instance.

1. To login, run the following:
**ssh -i instance1 root@[YOUR URL IN THE STEP ABOVE]**