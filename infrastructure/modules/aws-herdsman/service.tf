locals {
  control_port = 5000
}

resource "aws_cloudwatch_log_group" "herd_herdsman" {
  count = var.create_cloud_watch_group ? 1 : 0
  name = var.cloud_watch_group
}


locals {
  cloud_watch_group_name = var.create_cloud_watch_group ? aws_cloudwatch_log_group.herd_herdsman[0].name : var.cloud_watch_group
}

data "template_file" "herd_herdsman_task_definition" {
  template = file("${path.module}/templates/service.json")
  vars = {
    repository_url = aws_ecr_repository.herd.repository_url

    control_port = local.control_port
    host_port = var.port

    logs_region = var.aws_default_region
    cloudwatch_group = local.cloud_watch_group_name

    worker_hostname = var.worker_hostname
    worker_port = var.worker_port
  }
}

resource "aws_ecs_task_definition" "herdsman" {
  family                = "herd-herdsman"
  container_definitions = data.template_file.herd_herdsman_task_definition.rendered
  requires_compatibilities = ["EC2"]

  volume {
    name = "key"
    efs_volume_configuration {
      file_system_id = var.filesystem_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.key_storage_ap_id
      }
    }
  }

  volume {
    name = "data_frame"
    efs_volume_configuration {
      file_system_id = var.filesystem_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.data_frame_storage_ap_id
      }
    }
  }
}

resource "aws_ecs_service" "herd_herdsman" {
  name = "herd-herdsman"
  cluster = var.ecs_id
  task_definition = aws_ecs_task_definition.herdsman.arn
  launch_type = "EC2"
  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.herd_herdsman.arn
    container_name = "herdsman"
    container_port = local.control_port
  }

  depends_on = [
    aws_lb_listener.herd_herdsman
  ]
}