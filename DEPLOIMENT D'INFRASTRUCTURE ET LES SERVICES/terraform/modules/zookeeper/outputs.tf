output "zookeeper_ips" {
  value = "${aws_instance.zookeeper.*.private_ip}"
}
