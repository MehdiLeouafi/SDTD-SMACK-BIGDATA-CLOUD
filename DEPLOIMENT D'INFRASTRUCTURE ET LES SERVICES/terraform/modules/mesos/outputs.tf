output "mesos_master_ips" {
  value = "${aws_instance.mesos_master.*.private_ip}"
}

output "mesos_slave_ips" {
  value = "${aws_instance.mesos_slave.*.private_ip}"
}
