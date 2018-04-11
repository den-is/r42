data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam-role" {
  name = "suchapp"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ReadOnlyAccess" {
  role       = "${aws_iam_role.iam-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "suchapp" {
  name = "${aws_iam_role.iam-role.name}"
  role = "${aws_iam_role.iam-role.name}"
}
