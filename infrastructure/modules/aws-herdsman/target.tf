resource "aws_lb_target_group" "herd_herdsman" {
  name = "herd-herdsman"
  port = var.port
  protocol = "TCP"
  vpc_id = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "herd_herdsman" {
  load_balancer_arn = var.lb_id
  port = var.port
  protocol = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.herd_herdsman.arn
    type = "forward"
  }
}