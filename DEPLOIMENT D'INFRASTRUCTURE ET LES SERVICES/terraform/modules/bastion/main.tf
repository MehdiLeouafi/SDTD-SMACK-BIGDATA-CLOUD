resource "aws_key_pair" "deployer" {
  key_name = "${var.deployer_key_name}"
  public_key = "${var.deployer_public_key}"
}

resource "aws_instance" "bastion" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  security_groups = ["${var.security_group}"]
  root_block_device {
    delete_on_termination = true
    volume_size = 8
  }
  key_name = "deployer"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get install software-properties-common -y && sudo apt-get install python-pip python-dev build-essential -y && sudo pip install --upgrade pip  && sudo pip install --upgrade virtualenv  && sudo pip install ansible "
    ]
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }
}

