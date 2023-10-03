
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "allowed_sgs" {
  type = list(string)
}

variable "worker_role" {
  type = string
  default = ""
}

variable "worker_instance_profile" {
  type = string
  default = ""
}

variable "common_storage_ap_arn" {
  type = string
}

variable "worker_version" {
  type = string
}

variable "worker_artifact_name" {
  type = string
  default = "herdsman-lambda-worker.tar.gz"
}

variable "worker_release_base_url" {
  type = string
  default = "https://github.com/herd-fhe/aws_lambda_worker/releases/download/"
}

variable "worker_log_level" {
  type = string
  default = "trace"
}

variable "port" {
  type = number
  default = 5000
}