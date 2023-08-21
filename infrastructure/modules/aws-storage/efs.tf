resource "aws_efs_file_system" "herdsman-fs" {

}

resource "aws_efs_mount_target" "herdsman-fs-mount" {
  count = length(var.private_subnet_ids)

  file_system_id = aws_efs_file_system.herdsman-fs.id
  subnet_id = var.private_subnet_ids[count.index]
  security_groups = [aws_security_group.herdsman-fs-sg.id]
}