data "aws_subnet" "bastion_subnet" {
  id = "${var.bastion_subnet_id}"
}

resource "aws_security_group" "cluster_security_group" {
  name = "nodes security"
  description = "cluster nodes for configuration"
  vpc_id = "${aws_security_group.bastion_ssh_only.vpc_id}"

  # For provisionning
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["${var.bastion_private_ip}/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 20000 
    to_port     = 60999
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.bastion_subnet.cidr_block}"]
  }

}

resource "aws_security_group" "bastion_ssh_only" {
  name        = "Bastion security"
  description = "entry point for configuration"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "zookeeper_specific" {
  name = "zookeeper specific rules"
  description = "zookeeper specific security rules"
  vpc_id = "${aws_security_group.bastion_ssh_only.vpc_id}"

  ingress {
    from_port   = 3888
    to_port     = 3888
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.bastion_subnet.cidr_block}"]
  }

  ingress {
    from_port   = 2888
    to_port     = 2888
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.bastion_subnet.cidr_block}"]
  }

  ingress {
    from_port   = 2180
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.bastion_subnet.cidr_block}"]
  }

}

resource "aws_security_group" "mesos_specific" {
  name = "mesos specific rules"
  description = "mesos specific security rules"
  vpc_id = "${aws_security_group.bastion_ssh_only.vpc_id}"

  ingress {
    from_port   = 5050
    to_port     = 5051
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.bastion_subnet.cidr_block}"]
  }
  
}

resource "aws_security_group" "opscenter_specific" {
  name = "opscenter specific rules"
  description = "opscenter specific security rules"
  vpc_id = "${aws_security_group.bastion_ssh_only.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

resource "aws_security_group" "kafka_specific" {
  name = "kafka specific rules"
  description = "kafka specific security rules"
  vpc_id = "${aws_security_group.bastion_ssh_only.vpc_id}"

  ingress {
    from_port   = 9092
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.bastion_subnet.cidr_block}"]
  }
}

resource "aws_security_group" "cassandra_specific" {
  name = "cassandra specific rules"
  description = "cassandra specific security rules"
  vpc_id = "${aws_security_group.bastion_ssh_only.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_subnet.bastion_subnet.cidr_block}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  

}
