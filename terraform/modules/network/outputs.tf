# VPC ID
output "vpc_id" {
  value = aws_vpc.db_vpc.id
}

# Public Subnet ID
output "public_subnet_id" {
  value = aws_subnet.public.id
}

# Private Subnet 1 ID
output "private1_subnet_id" {
  value = aws_subnet.private1.id
}

# Private Subnet 2 ID
output "private2_subnet_id" {
  value = aws_subnet.private2.id
}

# Internet Gateway ID
output "igw_id" {
  value = aws_internet_gateway.db_igw.id
}

# NAT Gateway ID
output "nat_gw_id" {
  value = aws_nat_gateway.db_nat_gw.id
}
