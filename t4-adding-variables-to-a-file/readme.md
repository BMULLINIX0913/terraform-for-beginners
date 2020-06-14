# Working with Terraform and using a variable file.

Last updated: 06.14.2020

## Purpose

The purpose of this document is show how to replace all the variables
in your main.tf into a separate variable file.

## Prerequisites

None.

## Instructions

1. export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY"
1. export AWS_SECRET_ACCESS_KEY="YOUR SECRET KEY"
1. Generate a key pair `ssh-keygen -t rsa -f my_key`
1. chmod 400 ./my_key
1. cp ../t3-injecting-your-ssh-key-into-ec2-instance/main.tf .
1. Remove the following content from the *main.tf* and place the
content in a new file called *variables.tf*.

    ```hcl-terraform
           variable "region" {
             default = "us-east-1"
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
                 private = "my_key"
                 public = "my_key.pub"
               }
             }
           }
     ```
1. save the **main.tf** and the **variables.tf**
1. terraform init
1. Run `terraform plan` to find any errors and review
your deployment.
1. Run `terraform apply` to deploy your ec2 instance.
1. Wait 5 minutes
1. Run `terraform show | grep ec2-`

    The output of the previous step is your public url to the ec2 instance.

1. To login, run the following:

    **ssh -i my_key [The EC2 Default User]@[The IP Address in the Step Above]**

1. Run `terraform destroy`

    :warning: I noticed block device volumes were not deleted by the
    **terraform destroy**.  Make sure you check AWS to ensure all
    volumes are destroyed.  You could be charged for them.