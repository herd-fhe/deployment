locals {
  #common due to wrong implementation of lambda interface by aws
  common_path = "/herd"
  key_path = "/herd/key"
  data_frame_path = "/herd/data_frame"
  permissions = 700
}

resource "aws_efs_access_point" "common" {
  file_system_id = aws_efs_file_system.herdsman-fs.id

  posix_user {
    gid = var.owner_gid
    uid = var.owner_uid
  }

  root_directory {
    path = local.common_path
    creation_info {
      owner_gid   = var.owner_gid
      owner_uid   = var.owner_gid
      permissions = local.permissions
    }
  }

  depends_on = [
    aws_efs_mount_target.herdsman-fs-mount
  ]
}

resource "aws_efs_access_point" "keys_data" {
  file_system_id = aws_efs_file_system.herdsman-fs.id

  posix_user {
    gid = var.owner_gid
    uid = var.owner_uid
  }

  root_directory {
    path = local.key_path
    creation_info {
      owner_gid   = var.owner_gid
      owner_uid   = var.owner_gid
      permissions = local.permissions
    }
  }

  depends_on = [
    aws_efs_access_point.common
  ]
}

resource "aws_efs_access_point" "data_frame_data" {
  file_system_id = aws_efs_file_system.herdsman-fs.id

  posix_user {
    gid = var.owner_gid
    uid = var.owner_uid
  }

  root_directory {
    path = local.data_frame_path
    creation_info {
      owner_gid   = var.owner_gid
      owner_uid   = var.owner_uid
      permissions = local.permissions
    }
  }

  depends_on = [
    aws_efs_access_point.common
  ]
}