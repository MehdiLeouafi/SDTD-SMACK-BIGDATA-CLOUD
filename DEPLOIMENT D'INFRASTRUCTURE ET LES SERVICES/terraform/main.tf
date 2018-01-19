provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  version = "~>1.6"
  region = "${var.region}"
}

resource "aws_key_pair" "cluster_interconnection" {
  key_name = "${var.cluster_key_name}"
  public_key = "${var.cluster_public_key}"
}

module "bastion" {
  source = "./modules/bastion"

  deployer_key_name = "${var.deployer_key_name}"
  deployer_public_key = "${var.deployer_public_key}"
  ami = "${var.ami}"
  security_group = "${module.security_groups.bastion_ssh_only}"
  private_key_path = "./deployer"
}

module "security_groups" {
  source = "./modules/smack-security-group"
  
  bastion_subnet_id = "${module.bastion.subnet_id}"
  bastion_private_ip = "${module.bastion.bastion_private_ip}"

}
module "zookeeper" {
  source = "./modules/zookeeper"

  security_groups = ["${module.security_groups.cluster_security_group}", "${module.security_groups.zookeeper_specific}"]
  subnet_id = "${module.bastion.subnet_id}"
  ami = "${var.ami}"
  availability_zone = "${module.bastion.availability_zone}"
  cluster_private_key_path = "./cluster_interconnection"

}

module "mesos" {
  source = "./modules/mesos"

  security_groups = ["${module.security_groups.cluster_security_group}", "${module.security_groups.mesos_specific}"]
  subnet_id = "${module.bastion.subnet_id}"
  ami = "${var.ami}"
  availability_zone = "${module.bastion.availability_zone}"
  cluster_private_key_path = "./cluster_interconnection"
  master_instance_type = "${var.mesos_master_instance_type}"
  slave_instance_type = "${var.mesos_slave_instance_type}"
}

module "kafka" {
  source = "./modules/kafka"

  count = "${var.kafka_counts}"
  security_groups = ["${module.security_groups.cluster_security_group}", "${module.security_groups.kafka_specific}"]
  subnet_id = "${module.bastion.subnet_id}"
  ami = "${var.ami}"
  availability_zone = "${module.bastion.availability_zone}"
  cluster_private_key_path = "./cluster_interconnection"
  instance_type = "${var.kafka_instance_type}"
}

module "cassandra" {
  source = "./modules/cassandra"

  security_groups = ["${module.security_groups.cluster_security_group}", "${module.security_groups.cassandra_specific}"]
  subnet_id = "${module.bastion.subnet_id}"
  ami = "${var.cassandra_ami}"
  availability_zone = "${module.bastion.availability_zone}"
  cluster_private_key_path = "./cluster_interconnection"
  instance_size = "${var.cassandra_instance_size}"
  instance_type = "${var.cassandra_instance_type}"
  
}

module "opscenter" {
  source = "./modules/opscenter"

  security_groups = ["${module.security_groups.cluster_security_group}","${module.security_groups.opscenter_specific}"]
  subnet_id = "${module.bastion.subnet_id}"
  ami = "${var.cassandra_ami}"
  availability_zone = "${module.bastion.availability_zone}"
  cluster_private_key_path = "./cluster_interconnection"
  instance_type = "${var.opscenter_instance_type}"
  
}

module "producer" {
  source = "./modules/producer"

  security_groups = ["${module.security_groups.cluster_security_group}"]
  subnet_id = "${module.bastion.subnet_id}"
  ami = "${var.ami}"
  availability_zone = "${module.bastion.availability_zone}"
  cluster_private_key_path = "./cluster_interconnection"

}
