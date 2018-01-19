output "bastion_public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "availability_zone" {
  value = "${aws_instance.bastion.availability_zone}"
}

output "subnet_id" {
  value = "${aws_instance.bastion.subnet_id}"
}

output "bastion_private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}
