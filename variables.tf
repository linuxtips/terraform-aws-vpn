variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "client_cidr_block" {
  description = "IP CIDR block for the client VPN"
  type        = string
  default     = "192.168.0.0/16"
}

variable "server_certificate_arn" {
  description = "ARN of the server certificate"
  type        = string
}

variable "private_subnets" {
  description = "The Private subnets for the VPN"
  type        = list(string)
}

variable "component_name" {
  description = "The name of the component"
  type        = string
}

variable "environment_name" {
  description = "The name of the product environment"
  type        = string
}
