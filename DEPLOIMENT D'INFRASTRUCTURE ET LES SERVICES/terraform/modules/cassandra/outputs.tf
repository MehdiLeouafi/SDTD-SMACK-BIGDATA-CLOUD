output "cassandra_ips" {
  value = "${aws_instance.cassandra.*.private_ip}"
}

output "cassandra_public_ips" {
  value = "${aws_instance.cassandra.*.public_dns}"
}
