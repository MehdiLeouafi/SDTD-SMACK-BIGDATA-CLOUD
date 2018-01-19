resource "aws_instance" "mesos_master" {
  count = "${var.master_count}"

  ami           = "${var.ami}"
  availability_zone = "${var.availability_zone}"
  instance_type = "${var.master_instance_type}"
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

resource "aws_instance" "mesos_slave" {
  count = "${var.slave_count}"

  ami           = "${var.ami}"
  availability_zone = "${var.availability_zone}"
  instance_type = "${var.slave_instance_type}"
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
