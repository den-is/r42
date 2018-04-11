resource "aws_security_group" "suchapp" {
  name        = "suchapp"
  description = "suchapp instance sg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["172.31.0.0/16"]
    description = "Allow load balancer which reside in this cidr_block to contact instance on given port"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${var.myip}"]
    description = "Allow admin to ping instances"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${var.myip}"]
    description = "Allow admin to ssh into instances"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["${var.myip}"]
    description = "Allow admin direct access on service port"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["${var.pubip}"]
    description = "Allow some public IP direct access on service port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow whole outbound traffic"
  }

  tags {
    Name    = "suchapp"
    project = "r42"
  }

}

resource "aws_security_group" "suchapp_elb" {
  name        = "suchapp-elb"
  description = "suchapp ELB sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["${var.myip}"]
    description = "Allow admin direct access on service port"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["${var.pubip}"]
    description = "Allow some public IP direct access on service port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow whole outbound traffic"
  }

  tags {
    Name    = "suchapp-elb"
    project = "r42"
  }

}
