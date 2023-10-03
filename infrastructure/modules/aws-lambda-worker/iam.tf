resource "aws_iam_role" "herd_worker" {
  count = var.worker_role == "" ? 1 : 0
  name = "herd-worker"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

locals {
  iam_role_name = var.worker_role == "" ? aws_iam_role.herd_worker[0].name : var.worker_role
}


resource "aws_iam_role_policy_attachment" "herd_ecs_instance" {
  count = var.worker_role == "" ? 1 : 0

  role = local.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_role" "worker_role" {
  count = var.worker_role == "" ? 0 : 1
  name = var.worker_role
}

locals {
    iam_role_arn = var.worker_role != "" ? data.aws_iam_role.worker_role[0].arn : aws_iam_role.herd_worker[0].arn
}