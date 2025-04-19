variable "region" {
  type        = string
  # default     = "ap-southeast-1"
  default = "us-east-1"
  description = "AWS region"
}

variable "project_name" {
  type        = string
  default     = "devops-lab01"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "azs" {
  type        = list(string)
  # default     = ["ap-southeast-1a"]
  default = ["us-east-1a"]
}

variable "my_ip" {
  type        = string
  description = "Your static IP for SSH"
  default     = "0.0.0.0/0"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for instance"
  # default     = "ami-002fa10fbb7594252"
  default = "ami-01f5a0b78d6089704"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  default     = "my-keypair"
  description = "Key pair name for SSH"
}
