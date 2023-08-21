output "filesystem_id" {
  value = aws_efs_file_system.herdsman-fs.id
}

output "common_ap" {
  value = {
    id = aws_efs_access_point.common.id
    arn = aws_efs_access_point.common.arn
  }
}

output "key_storage_ap" {
  value = {
    id  = aws_efs_access_point.keys_data.id
    arn = aws_efs_access_point.keys_data.arn
  }
}

output "data_frame_storage_ap" {
  value = {
    id = aws_efs_access_point.data_frame_data.id
    arn = aws_efs_access_point.data_frame_data.arn
  }
}