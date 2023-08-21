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
  # Name of key: Write the custom name of your key
  key_name   = "aws_keys_pairs"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.ed25519-example.public_key_openssh



  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory

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
  iam_instance_profile = aws_iam_instance_profile.herd_ecs_instance.arn
  security_groups = [aws_security_group.herd_ecs_instance.id]

  associate_public_ip_address = true
  key_name = aws_key_pair.generated_key.key_name

  user_data = data.cloudinit_config.herd_ecs_instance_config.rendered
}

resource "aws_autoscaling_group" "herdsman_autoscaling" {
  name = "herdsman-autoscaling"
  vpc_zone_identifier = var.private_subnet_ids
  launch_configuration = aws_launch_configuration.herdsman-launch-configuration.name

  desired_capacity = 1
  min_size = 1
  max_size = 1
}
