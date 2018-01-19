variable "access_key" {}

variable "secret_key" {}

variable "region" {}

variable "deployer_key_name" {}

variable "deployer_public_key" {}

variable "cluster_key_name" {}

variable "cluster_public_key" {}

variable "kafka_counts" {
  default = "2"
}

variable "ami" {
  default = "ami-82f4dae7" #Ubuntu 16.04
}

variable "cassandra_ami" {
  default = "ami-82f4dae7" #Ubuntu 16.04
}

variable "instance_type" {
  default = "t2.micro"
}

variable "mesos_master_instance_type" {
  default = "t2.micro"
}

variable "mesos_slave_instance_type" {
  default = "t2.micro"
}

variable "kafka_instance_type" {
  default = "t2.micro"
}

variable "cassandra_instance_size" {
  default = "8"
}

variable "cassandra_instance_type" {
  default = "t2.micro"
}

variable "opscenter_instance_type" {
  default = "t2.micro"
}
