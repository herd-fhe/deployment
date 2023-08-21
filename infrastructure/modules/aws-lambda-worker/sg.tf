locals {
  lambda_port = 9001
}

resource "aws_security_group" "herd_worker_load_balancer" {
  name = "herd-worker-load-balancer"

  vpc_id = var.vpc_id

  ingress {
    from_port = var.port
    to_port = var.port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
#    security_groups = var.allowed_sgs  todo: unlock it
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "herd_worker_lambda" {
  name = "herd-worker-lambda"

  vpc_id = var.vpc_id

  ingress {
    from_port = local.lambda_port
    to_port = local.lambda_port
    protocol = "tcp"
    security_groups = [
      aws_security_group.herd_worker_load_balancer.id
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}