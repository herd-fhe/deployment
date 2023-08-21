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

variable "worker_hostname" {
  type = string
}

variable "worker_port" {
  type = number
  default = 5000
}

variable "port" {
  type        = number
  default     = 5000
  description = "Herdsman port"
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