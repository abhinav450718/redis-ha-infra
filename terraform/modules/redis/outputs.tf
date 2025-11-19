output "id" {
  value = aws_instance.redis.id
}

output "private_ip" {
  value = aws_instance.redis.private_ip
}

output "name" {
  value = var.name
}

output "role_type" {
  value = var.role_type
}

