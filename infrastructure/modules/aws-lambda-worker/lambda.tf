locals {
  common_map_point = "/mnt/herd"
  key_map_point = "${local.common_map_point}/key"
  data_frame_map_point = "${local.common_map_point}/data_frame"
}

resource "aws_cloudwatch_log_group" "herd_worker" {
  name = "herd-worker"
}

resource "aws_lambda_function" "herd_worker" {
  function_name = "worker"
  role          = local.iam_role_arn

  filename = local.artifact_name
  handler = "aws_lambda_worker"
  runtime = "provided"

  timeout = 900

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [
      aws_security_group.herd_worker_lambda.id
    ]
  }

  environment {
    variables = {
      KEY_BASE_DIR = local.key_map_point
      STORAGE_BASE_DIR = local.data_frame_map_point
      LOG_LEVEL = var.worker_log_level
      INVOKER = "API_CALL"
    }
  }

  file_system_config {
    arn              = var.common_storage_ap_arn
    local_mount_path = local.common_map_point
  }

  depends_on = [
    null_resource.herd_worker_body
  ]
}