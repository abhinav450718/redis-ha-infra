variable "subnet_id" {
  description = "The subnet ID where the bastion host will be launched"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}

variable "key_name" {
  description = "SSH key name for the bastion host"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security Group ID for the bastion host"
  type        = string
}
