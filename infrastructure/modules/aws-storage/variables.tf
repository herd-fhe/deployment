variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "allowed_sgs" {
  type = list(string)
}

variable "owner_uid" {
  type = number
  default = 1000
}

variable "owner_gid" {
  type = number
  default = 1000
}