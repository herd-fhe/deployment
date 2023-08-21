locals {
  artifact_name = "aws_lambda_worker.zip"
}

resource "null_resource" "herd_worker_body" {
  triggers = {
    on_repository_change = var.worker_release_base_url
    on_version_change = var.worker_version
    on_artifact_name_change = var.worker_artifact_name
  }

  provisioner "local-exec" {
    command = <<EOF
curl -Ls ${var.worker_release_base_url}${var.worker_version}/${var.worker_artifact_name} \
  | tar --extract -z --strip-components=1 release/aws_lambda_worker.zip
EOF
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm aws_lambda_worker.zip"
  }
}