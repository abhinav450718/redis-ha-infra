variable "subnet_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "db_sg_id" {}
variable "name" {}        # e.g. "redis-master" or "redis-replica"
variable "role_type" {}   # e.g. "master" or "replica"
