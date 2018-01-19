output "opscenter_ip" {
  value = "${aws_instance.opscenter.*.private_ip}"
}

output "opscenter_public_ip" {
  value = "${aws_instance.opscenter.*.public_dns}"
}