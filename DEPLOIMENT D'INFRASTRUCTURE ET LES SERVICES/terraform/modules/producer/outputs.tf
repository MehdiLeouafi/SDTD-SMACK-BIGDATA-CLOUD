output "producer_ip" {
  value = "${aws_instance.producer.*.private_ip}"
}
