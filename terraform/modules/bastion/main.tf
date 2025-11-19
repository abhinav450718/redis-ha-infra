variable "subnet_id" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "bastion_sg_id" {}

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.bastion_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
    Role = "bastion"
  }
}

output "bastion_id" {
  value = aws_instance.bastion.id
}
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
