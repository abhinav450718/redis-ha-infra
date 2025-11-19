##########################
# VPC
##########################
resource "aws_vpc" "db_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "db_vpc"
  }
}

##########################
# Internet Gateway
##########################
resource "aws_internet_gateway" "db_igw" {
  vpc_id = aws_vpc.db_vpc.id
  tags = {
    Name = "db_igw"
  }
}

##########################
# Elastic IP for NAT
##########################
resource "aws_eip" "nat" {
  # No vpc argument needed
  tags = {
    Name = "nat-eip"
  }
}

##########################
# NAT Gateway
##########################
resource "aws_nat_gateway" "db_nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "db-nat-gw"
  }
}

##########################
# Subnets
##########################

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.db_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

# Private Subnet 1
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.private1_subnet_cidr
  availability_zone = "sa-east-1b"
  tags = {
    Name = "private_subnet_1"
  }
}

# Private Subnet 2
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = var.private2_subnet_cidr
  availability_zone = "sa-east-1c"
  tags = {
    Name = "private_subnet_2"
  }
}

##########################
# Route Tables
##########################

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.db_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.db_igw.id
  }
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.db_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.db_nat_gw.id
  }
  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "private_assoc1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}

