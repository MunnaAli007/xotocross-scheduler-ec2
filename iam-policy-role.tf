resource "aws_iam_policy" "xotocross-policy" { 
    name = "xotocross-${var.xotocross-bucket-name}-policy"
    path = "/"
    description = "xotocross Policy for Lambda function to control start and stop of EC2 instances"
    policy = "${file("./credentials/xotocross_policy.json")}"
}

resource "aws_iam_role" "xotocross-role" { 
    name = "xotocross-${var.xotocross-bucket-name}-role"
    path = "/"
    description = "xotocross allows Lambda function to control start and stop of EC2 instances."
    assume_role_policy = "${file("./credentials/xotocross_role.json")}"
}

resource "aws_iam_policy_attachment" "xotocross-iam-policy-role" {
    name = "xotocross-${var.xotocross-bucket-name}-iam-policy-role"
    roles = ["${aws_iam_role.xotocross-role.name}"] # admin
    policy_arn = "${aws_iam_policy.xotocross-policy.arn}"
}
