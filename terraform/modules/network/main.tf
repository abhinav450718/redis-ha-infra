resource "aws_vpc" "db_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "db-vpc" }
}

resource "aws_internet_gateway" "db_igw" {
  vpc_id = aws_vpc.db_vpc.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "db_nat_gw" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat.id
}

# Public Subnet (bastion)
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

# Private DB subnet-1 (master)
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
}

# Private DB subnet-2 (replica)
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.db_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.db_igw.id
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
}

resource "aws_route_table_association" "private_assoc1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}
