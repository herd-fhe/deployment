variable "aws_default_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "ecs_instance_role" {
  type        = string
  default     = ""
}

variable "inbound_ports" {
  type = list(number)
}
