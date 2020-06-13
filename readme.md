# Working with Terraform

Last updated: 06.13.2020

## Purpose

The purpose of this document is to show how to install and work with Terraforms.

## Prerequisites

None

### Installation

1. sudo yum -y install wget unzip

1. Download Terraform:

    ```shell script
     export VER="0.12.26"
     wget https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip
    ```

1. tar -xvf terraform_${VER}_linux_amd64.zip
1. sudo mv terraform /usr/local/bin

### Amazon

#### Prerequisites for Amazon Terraform Provider

##### You must have an Amazon AWS Account

##### After you create your account, You must create a new IDM User

1. Click on **Services** menu
1. Click on **IAM** link
1. Click on the **Users** link on the left menu.
1. Click the **Add User** button
1. In the **User Name** text box, enter the user name
1. Under the **Access Type** section, select the checkbox **Progammatic Access**
1. Click the **Next: Permissions** button
1. Click the **Create Group** button
1. In the **Group Name** text box, enter **EC2Editor**
1. Give the group the **AmazonEC2FullAccess** policy
1. Click on the **Create Group** button
1. Click on the **Next: Tags** button
1. Click on the **Next: Review** button
1. Click on the **Create User** button
1. Click on the **Download .csv** button.

:warning: The downloaded .csv will be called **credentials.csv**.
Keep this file safe.  It contains your **AWS Access Key ID** and your
**AWS Secret Access Key**.  These keys can give any users access to your
environment and cost you money.

##### Add Environment Variables for each Terraform Terminal

1. export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY"
1. export AWS_SECRET_ACCESS_KEY="YOUR SECRET KEY"

#### Instructions
1. mkdir getting_started
1. cd getting_started
1. create the **main.tf** file
1. open the **main.tf** file
1. Specify the AWS provider:

    ```hcl-terraform
    provider "aws" {
      region = "us-east-1"}
    ```

1. Specify the Security Group to use for the VPC:

   ```hcl-terraform
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
    ```

1. Specify the EC2 Instance to launch:

   ```hcl-terraform
    resource "aws_instance" "master1_centos" {
      ami           = "ami-0ff750889570c0406"
      instance_type = "t2.medium"
      vpc_security_group_ids = [aws_security_group.instance.id]
      tags          = { Name = "master" }

    }
    ```

    :warning: The **AMI** describes the image to use in your region.  The
    **AMI** might not be available in your Amazon Region.  Please find the
    **AMI** by performing the steps in the
    [getting started with aws](https://github.com/bretmullinix/getting-started-working-with-aws) repo.

1. Save the file.
1. Initiate your Terraform environment by running `terraform init`
1. To show you the list of dependencies in your **main.tf** run `terraform graph`.
1. Validate your **main.tf** by running `terraform plan`
1. Run your environment by running `terraform apply`
1. Destroy your environment by running `terraform destroy`
