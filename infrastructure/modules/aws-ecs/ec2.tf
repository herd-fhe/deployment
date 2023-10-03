data "cloudinit_config" "herd_ecs_instance_config" {
  gzip          = false
  base64_encode = true

    part {
    content_type = "text/x-shellscript"
    content      = <<EOT
#!/bin/bash
echo ECS_CLUSTER="${aws_ecs_cluster.herd.name}" >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
EOT
  }
}

resource "tls_private_key" "ed25519-example" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "aws_keys_pairs"

  public_key = tls_private_key.ed25519-example.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ed25519-example.private_key_pem}' > aws_keys_pairs.pem
      chmod 400 aws_keys_pairs.pem
    EOT
  }
}

resource "aws_launch_configuration" "herdsman-launch-configuration" {
  image_id      = local.ami_id
  instance_type = "t2.micro"
  iam_instance_profile = local.iam_instance_profile
  security_groups = [aws_security_group.herd_ecs_instance.id]

  associate_public_ip_address = true
  key_name = aws_key_pair.generated_key.key_name

  user_data = data.cloudinit_config.herd_ecs_instance_config.rendered
}

data "aws_default_tags" "current" {
}

resource "aws_autoscaling_group" "herdsman_autoscaling" {
  name = "herdsman-autoscaling"
  vpc_zone_identifier = var.private_subnet_ids
  launch_configuration = aws_launch_configuration.herdsman-launch-configuration.name

  desired_capacity = 1
  min_size = 1
  max_size = 1

  dynamic "tag" {
    for_each = data.aws_default_tags.current.tags
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}
