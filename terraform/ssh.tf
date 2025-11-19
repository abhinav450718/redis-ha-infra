resource "tls_private_key" "redis_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "redis_key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.redis_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.redis_key.private_key_pem
  filename        = "${path.module}/redis_key.pem"
  file_permission = "0400"
}
