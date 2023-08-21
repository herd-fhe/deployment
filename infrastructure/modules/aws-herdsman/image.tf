#Not the best solution but working one
#
locals {
  herdsman_image_path = "../../../herdsman-image"
  herdsman_nix_path = "${local.herdsman_image_path}/default.nix"
}

resource "aws_ecr_repository" "herd" {
  name = "herd"
  force_delete = true
}

data "aws_ecr_authorization_token" "herd" {
}

resource "null_resource" "nix_image_build_push" {
  triggers = {
    source_hash = sha512(file(local.herdsman_nix_path))
  }

  provisioner "local-exec" {

    command = <<EOF
cd ${local.herdsman_image_path}
echo ${data.aws_ecr_authorization_token.herd.password} | docker login --username ${data.aws_ecr_authorization_token.herd.user_name} ${data.aws_ecr_authorization_token.herd.proxy_endpoint} --password-stdin
nix-build
docker load < result
docker tag herdsman:latest ${aws_ecr_repository.herd.repository_url}:latest
docker image push ${aws_ecr_repository.herd.repository_url}:latest
docker image rm herdsman:latest
EOF
  }
}