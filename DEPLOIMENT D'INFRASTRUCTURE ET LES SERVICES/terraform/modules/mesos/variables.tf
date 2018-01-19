variable "master_count" {
  default = 2 
}

variable "slave_count" {
  default = 3
}

variable "security_groups" {
  type = "list"
}

variable "subnet_id" {}

variable "cluster_private_key_path" {}

variable "ami" {}

variable "availability_zone" {}

variable "master_instance_type" {}

variable "slave_instance_type" {}
