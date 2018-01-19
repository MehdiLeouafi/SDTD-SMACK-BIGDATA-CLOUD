resource "aws_instance" "cassandra" {
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


  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file(var.cluster_private_key_path)}"
  }
}
