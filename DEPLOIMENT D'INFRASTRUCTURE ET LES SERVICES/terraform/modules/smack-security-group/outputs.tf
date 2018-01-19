output "cluster_security_group" {
  value = "${aws_security_group.cluster_security_group.id}"
}

output "bastion_ssh_only" {
  value = "${aws_security_group.bastion_ssh_only.name}"
}

output "mesos_specific" {
  value = "${aws_security_group.mesos_specific.id}"
}

output "zookeeper_specific" {
  value = "${aws_security_group.zookeeper_specific.id}"
}

output "kafka_specific" {
  value = "${aws_security_group.kafka_specific.id}"
}

output "cassandra_specific" {
  value = "${aws_security_group.cassandra_specific.id}"
}

output "opscenter_specific" {
  value = "${aws_security_group.opscenter_specific.id}"
}