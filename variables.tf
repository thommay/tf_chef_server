variable "region" {
  default = "us-west-2"
}

variable "ssh_user" {
  description = "The user to ssh as"
}

variable "ami" {
  description = "Base AMI for all nodes"

  default = {
    us-west-2 = "ami-746aba14"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "subnet_id" {
  description = "The EC2 subnet ID to create the chef server in"
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs"
}

variable "private_ssh_key_path" {
  description = "The path to your ssh key"
}

variable "key_name" {
  description = "The name of your AWS key pair"
}

variable "chef_server_version" {
  description = "The version of Chef Server to install"
  default     = "12.9.1"
}

variable "chef_server_user" {
  description = "The account name of the chef admin user"
}

variable "chef_server_user_full_name" {
  description = "The full name of the chef admin user"
}

variable "chef_server_user_email" {
  description = "The email of the chef admin user"
}

variable "chef_server_user_password" {
  description = "The password of the chef admin user"
}

variable "chef_server_org_name" {
  description = "The name of the chef organization"
}

variable "chef_server_org_full_name" {
  description = "The display name of the chef organization"
}

variable "chef_server_addons" {
  description = "A comma separated string of chef server addons"
  default     = ""
}

variable "chef_server_addvers" {
  description = "A comma separated string of chef server addon versions"
  default     = ""
}
