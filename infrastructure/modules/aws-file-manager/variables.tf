variable "aws_default_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_id" {
  type = string
}

variable "ecs_id" {
  type = string
}

variable "lb_id" {
  type = string
}

variable "port" {
  type        = number
  default     = 8080
  description = "File manager port"
}

variable "filesystem_id" {
  type = string
}

variable "key_storage_ap_id" {
  type = string
}

variable "data_frame_storage_ap_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password_hash" {
  type = string
}

variable "cloud_watch_group" {
  type = string
  default = "herd-file-manager-logs"
}

variable "create_cloud_watch_group" {
  type = bool
  default = true
}