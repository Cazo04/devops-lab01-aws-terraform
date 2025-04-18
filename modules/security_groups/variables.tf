variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created."
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group."
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks  = list(string)
  }))
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules for the security group."
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks  = list(string)
  }))
  default     = []
}