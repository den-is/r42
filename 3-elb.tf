data "aws_availability_zones" "all" {}

resource "aws_elb" "elb" {
  name               = "suchapp"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.suchapp_elb.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/hello"
    interval            = 30
  }

  cross_zone_load_balancing = false
  idle_timeout              = 60
  connection_draining       = false

  tags {
    project = "r42"
  }
}
