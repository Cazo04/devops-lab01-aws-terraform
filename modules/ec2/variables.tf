variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instance"
  type        = list(string)
}

variable "instance_count" {
  description = "The number of EC2 instances to launch"
  type        = number
  default     = 1
}