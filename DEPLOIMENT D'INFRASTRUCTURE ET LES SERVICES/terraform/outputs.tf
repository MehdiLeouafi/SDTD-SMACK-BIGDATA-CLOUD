output "cassandra_ips" {
  value = "${module.cassandra.cassandra_ips}"
}

output "cassandra_public_ips" {
  value = "${module.cassandra.cassandra_public_ips}"
}

output "bastion_public_ip" {
  value = "${module.bastion.bastion_public_ip}"
}

output "opscenter_ip" {
  value = "${module.opscenter.opscenter_ip}"
}

output "opscenter_public_ip" {
  value = "${module.opscenter.opscenter_public_ip}"
}

output "zookeeper_ips" {
  value = "${module.zookeeper.zookeeper_ips}"
}

output "kafka_ips" {
  value = "${module.kafka.kafka_ips}"
}

output "mesos_master_ips" {
  value = "${module.mesos.mesos_master_ips}"
}

output "mesos_slave_ips" {
  value = "${module.mesos.mesos_slave_ips}"
}

output "producer_ip" {
  value = "${module.producer.producer_ip}"
}
