variable "project_name" {
  type        = string
  description = "Project name"
}

variable "public_subnet_id" {
  type        = string
  description = "Subnet ID for Public EC2"
}

variable "private_subnet_id" {
  type        = string
  description = "Subnet ID for Private EC2"
}

variable "public_sg_id" {
  type        = string
  description = "Security Group ID for Public EC2"
}

variable "private_sg_id" {
  type        = string
  description = "Security Group ID for Private EC2"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2"
}

variable "instance_type" {
  type        = string
  description = "Instance type (e.g., t2.micro)"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "AWS Key Pair name for SSH"
}
