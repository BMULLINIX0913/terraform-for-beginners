resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/templates/ansible-inventory.tpl",
    {
     master1_centos_ip = aws_instance.master1_centos.public_ip
    })
  filename = "./terraform_output/ansible-inventory"
}