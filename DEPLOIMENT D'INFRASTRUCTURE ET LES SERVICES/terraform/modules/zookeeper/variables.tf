variable "count" {
  default = 3
}

variable "instance_type" {
  default = "t2.micro"
}

variable "security_groups" {
  type = "list"
}

variable "subnet_id" {}

variable "cluster_private_key_path" {}

variable "ami" {}

variable "availability_zone" {}
