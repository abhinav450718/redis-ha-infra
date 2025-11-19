variable "subnet_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "db_sg_id" {}
variable "name" {}        # e.g. "redis-master" or "redis-replica"
variable "role_type" {}   # e.g. "master" / "replica"

resource "aws_instance" "redis" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.db_sg_id]
  associate_public_ip_address = false

  tags = {
    Name     = var.name
    Role     = "redis"
    RoleType = var.role_type
  }
}

output "id" {
  value = aws_instance.redis.id
}
output "private_ip" {
  value = aws_instance.redis.private_ip
}
output "name" {
  value = var.name
}
