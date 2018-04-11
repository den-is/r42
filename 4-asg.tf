data "aws_subnet_ids" "subnets" {
  vpc_id = "${var.vpcid}"
}

resource "aws_launch_configuration" "launch_config" {
  name                        = "suchapp"
  image_id                    = "ami-6283ef0d"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.suchapp.arn}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.suchapp.id}"]
  user_data                   = "${file("user_data.sh")}"
  associate_public_ip_address = false
}

resource "aws_autoscaling_group" "asg" {
  depends_on                = ["aws_launch_configuration.launch_config"]
  count                     = "${length(data.aws_subnet_ids.subnets.ids)}"
  name                      = "suchapp-${count.index}"
  vpc_zone_identifier       = ["${element(data.aws_subnet_ids.subnets.ids, count.index)}"]
  launch_configuration      = "${aws_launch_configuration.launch_config.id}"
  load_balancers            = ["${aws_elb.elb.name}"]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1

  tags = [
    {
      key                 = "Name"
      value               = "suchapp-${count.index}"
      propagate_at_launch = true
    },
    {
      key                 = "project"
      value               = "r42"
      propagate_at_launch = true
    }
  ]
}
