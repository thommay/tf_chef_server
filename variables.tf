variable "region" {
  default = "us-west-2"
}

variable "aws_ami" {
  description = "Base AMI for all nodes"

  default = {
    us-west-2 = "ami-746aba14"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "subnet_id" {}
variable "vpc_security_group_ids" {}
variable "private_ssh_key_path" {}
variable "key_name" {}
variable "chef-server-version" {}
variable "chef-server-user" {}
variable "chef-server-user-full-name" {}
variable "chef-server-user-email" {}
variable "chef-server-user-password" {}
variable "chef-server-org-name" {}
variable "chef-server-org-full-name" {}
variable "chef-server-addons" {}
