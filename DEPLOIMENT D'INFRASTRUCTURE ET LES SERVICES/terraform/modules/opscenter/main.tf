resource "aws_instance" "opscenter" {
  count = "${var.count}"

  ami           = "${var.ami}"
  availability_zone = "${var.availability_zone}"
  instance_type = "${var.instance_type}"
  security_groups = ["${var.security_groups}"]
  subnet_id = "${var.subnet_id}"
  root_block_device {
    delete_on_termination = true
    volume_size = 8
  }

  key_name = "cluster_interconnection"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get install software-properties-common -y && sudo apt-get install python -y",
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file(var.cluster_private_key_path)}"
  }
}
