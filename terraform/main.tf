provider "aws" {
  region = "sa-east-1"
}

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Network Module
module "network" {
  source = "./modules/network"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.0.0/24"
  private1_subnet_cidr = "10.0.1.0/24"
  private2_subnet_cidr = "10.0.2.0/24"

  az_public   = "sa-east-1a"
  az_private1 = "sa-east-1b"
  az_private2 = "sa-east-1c"
}

# -------------------------
# Security Groups
# -------------------------

# Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  vpc_id      = module.network.vpc_id
  description = "bastion ssh sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# DB / Redis SG
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  vpc_id      = module.network.vpc_id
  description = "DB security group: redis inside VPC and SSH from bastion"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Redis within VPC"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "SSH from bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

# -------------------------
# Bastion Host Module
# -------------------------
module "bastion" {
  source        = "./modules/bastion"
  subnet_id     = module.network.public_subnet_id
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.redis_key_pair.key_name
  bastion_sg_id = aws_security_group.bastion_sg.id
}

# -------------------------
# Redis Master
# -------------------------
module "redis_master" {
  source        = "./modules/redis"
  subnet_id     = module.network.private1_subnet_id
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.redis_key_pair.key_name
  db_sg_id      = aws_security_group.db_sg.id
  name          = "redis-master"
  role_type     = "master"
}

# -------------------------
# Redis Replica
# -------------------------
module "redis_replica" {
  source        = "./modules/redis"
  subnet_id     = module.network.private2_subnet_id
  ami_id        = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.redis_key_pair.key_name
  db_sg_id      = aws_security_group.db_sg.id
  name          = "redis-replica"
  role_type     = "replica"
}



