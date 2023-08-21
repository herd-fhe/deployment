output "ecs" {
  value = {
    id   = aws_ecs_cluster.herd.id
    name = aws_ecs_cluster.herd.name
  }
}

output "instances_sg_id" {
  value = aws_security_group.herd_ecs_instance.id
}