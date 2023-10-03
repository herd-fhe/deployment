variable "aws_default_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "file_manager_port" {
  type        = number
  default     = 8080
  description = "File manager port"
}

variable "herdsman_port" {
  type        = number
  default     = 5000
  description = "Herdsman port"
}

variable "admin_username" {
  type = string
  default = "admin"
}

variable "admin_password_hash" {
  type = string
  default = "$2y$05$dssAMSFVermL8P/qkPRN7OndRkpNStXSAybOos0PyXDyw6RTTzbXa"
}

variable "herdsman_version" {
  type = string
  default = "v0.0.10"
}

variable "worker_version" {
  type = string
  default = "v0.0.8"
}