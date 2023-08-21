data "aws_ssm_parameter" "herd_ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

locals {
  ami_id = data.aws_ssm_parameter.herd_ecs_ami.value
}