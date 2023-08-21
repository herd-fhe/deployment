resource "aws_lb_target_group" "herd_file_manager" {
  name = "herd-file-manager"
  port = var.port
  protocol = "TCP"
  vpc_id = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "herd_file_manager" {
  load_balancer_arn = var.lb_id
  port = var.port
  protocol = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.herd_file_manager.arn
    type = "forward"
  }
}