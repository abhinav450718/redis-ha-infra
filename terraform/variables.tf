variable "region" { default = "eu-east-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "instance_type" { default = "t3.micro" }
variable "ssh_key_name" { default = "redis-key" }
variable "ami_owner" { default = "099720109477" } # canonical ubuntu
