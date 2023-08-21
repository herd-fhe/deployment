variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"

  description = "CIDR block to be assigned to vpc"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 32))
    error_message = "Must be valid IPv4 CIDR."
  }
}