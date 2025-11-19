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
