locals {
  control_port = 80
}

resource "aws_cloudwatch_log_group" "herd_file_manager" {
  name = "herd-file-manager-logs"
}

data "template_file" "herd_file_manager_task_definition" {
  template = file("${path.module}/templates/service.json")
  vars = {
    control_port = local.control_port
    host_port = var.port

    logs_region = var.aws_default_region
    cloudwatch_group = aws_cloudwatch_log_group.herd_file_manager.name

    admin_username = var.admin_username
    admin_password_hash = var.admin_password_hash
  }
}

resource "aws_ecs_task_definition" "herd_file_manager" {
  family                = "herd-file-manager"
  container_definitions = data.template_file.herd_file_manager_task_definition.rendered
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

resource "aws_ecs_service" "herd_file_manager" {
  name = "herd-file-manager"
  cluster = var.ecs_id
  task_definition = aws_ecs_task_definition.herd_file_manager.arn
  launch_type = "EC2"
  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.herd_file_manager.arn
    container_name = "ifm"
    container_port = local.control_port
  }

  depends_on = [ aws_lb_listener.herd_file_manager ]
}