# Working with Terraform and placing output in a file.

Last updated: 06.14.2020

## Purpose

The purpose of this document is show how to place output in a template file
and output the contents to a file.

## Prerequisites

None.

## Instructions

1. export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY"
1. export AWS_SECRET_ACCESS_KEY="YOUR SECRET KEY"
1. Generate a key pair `ssh-keygen -t rsa -f my_key`
1. chmod 400 ./my_key
1. cp ../t4-adding-variables-to-a-file/main.tf .
1. cp ../t4-adding-variables-to-a-file/variables.tf .
1. mkdir templates
1. cd templates
1. vi ansible-inventory.tpl
1. Add the following content:
    
    ```
    [all]
    master1-ocp ansible_host=${master1_centos_ip}
    ```
    
    The file is a Terraform template file for an Ansible Inventory.
    The Terraform template file is used as the template input for
    the **local_file** resource defined in the coming steps. 
    To learn more about Ansible
    [read the tutorial here](https://github.com/bretmullinix/ansbile-for-beginners).
    
1. Save the file.
1. cd ..
1. vi output.tf
1. Add the following content:

    ```hcl-terraform
    resource "local_file" "ansible-inventory" {
      content = templatefile("${path.module}/templates/ansible-inventory.tpl",
        {
          master1_centos_ip = aws_instance.master1_centos.public_ip
        }
      )
      filename = "./terraform_output/ansible-inventory"
    }   
    ```
    The resource above does the following:
    
    1. Uses the **aws_instance.master1_centos.public_ip** variable.  The 
    variable is the public IP for the **master1_centos** EC2 instance that
    is created in the **main.tf**.
    
    1. Takes the **aws_instance.master1_centos.public_ip** and assigns it to
    the input variable **master1_centos_ip** used in the **ansible-inventory.tpl**
    template file.
    
    1. Replaces the **master1_centos_ip** in the **ansible-inventory.tpl** file
    and creates the output Ansible Inventory file called
    **./terraform_output/ansible-inventory**.
    
1. Save the file.
1. terraform init
1. Run `terraform plan` to find any errors and review
your deployment.
1. Run `terraform apply` to deploy your ec2 instance.
1. Wait 5 minutes
1. cat terraform_output/ansible-inventory
1. To login, run the following:

    **ssh -i my_key [The EC2 Default User]@[The IP Address in the Step Above]**

1. Run `terraform destroy`

    :warning: I noticed block device volumes were not deleted by the
    **terraform destroy**.  Make sure you check AWS to ensure all
    volumes are destroyed.  You could be charged for them.