resource "aws_alb" "herd_worker" {
  name = "herd-worker"

  internal = false
  subnets = var.private_subnet_ids
  security_groups = [
    aws_security_group.herd_worker_load_balancer.id
  ]
}

resource "aws_lambda_permission" "herd_worker_lambda_lb" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.herd_worker.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_alb_target_group.herd_worker.arn
}

resource "aws_alb_target_group" "herd_worker" {
  name = "herd-worker"
  target_type = "lambda"

  vpc_id = var.vpc_id
}

resource "aws_alb_target_group_attachment" "herd_worker" {
  target_group_arn = aws_alb_target_group.herd_worker.arn
  target_id        = aws_lambda_function.herd_worker.arn

  depends_on = [
    aws_lambda_permission.herd_worker_lambda_lb
  ]
}

resource "aws_alb_listener" "herd_worker_lambda" {
  load_balancer_arn = aws_alb.herd_worker.id
  port = var.port
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.herd_worker.id
  }
}