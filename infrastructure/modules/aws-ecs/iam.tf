resource "aws_iam_role" "herd_ecs_instance_role" {
  count = (var.ecs_instance_role == "" && var.ecs_instance_profile == "") ? 1 : 0
  name = "herd-ecs-instance"
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

resource "aws_iam_role_policy_attachment" "herd_ecs_instance" {
  count = (var.ecs_instance_role == "" && var.ecs_instance_profile == "") == "" ? 1 : 0

  role = local.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

locals {
  iam_role_name = var.ecs_instance_role == "" ? (var.ecs_instance_profile != "" ? "" : aws_iam_role.herd_ecs_instance_role[0].name) : var.ecs_instance_role
}

resource "aws_iam_instance_profile" "herd_ecs_instance" {
  count = var.ecs_instance_profile == "" ? 1 : 0
  name = "herd-ecs-instance"
  role = local.iam_role_name
}

locals {
  iam_instance_profile = var.ecs_instance_profile == "" ? aws_iam_instance_profile.herd_ecs_instance[0].arn : var.ecs_instance_profile
}