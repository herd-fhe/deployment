resource "aws_lb" "herd" {
  name = "herd-herdsman"
  subnets = var.public_subnet_ids

  load_balancer_type = "network"
}