locals {
  nfs_port = 2049
}

resource "aws_security_group" "herdsman-fs-sg" {
  name = "herdsman-fs"
  description = "Allow EFS inbound traffic only from specified SGs"

  vpc_id = var.vpc_id

  ingress {
    description = "NFS traffic"
    from_port = local.nfs_port
    to_port = local.nfs_port
    protocol = "tcp"
    security_groups = var.allowed_sgs
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}