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
