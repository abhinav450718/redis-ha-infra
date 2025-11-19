variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private1_subnet_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "private2_subnet_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
}

variable "az_public" {
  description = "Availability Zone for public subnet"
  type        = string
}

variable "az_private1" {
  description = "Availability Zone for private subnet 1"
  type        = string
}

variable "az_private2" {
  description = "Availability Zone for private subnet 2"
  type        = string
}
