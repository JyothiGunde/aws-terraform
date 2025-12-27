provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

   tags = {
    Name = var.project
  }
}

resource "aws_subnet" "Public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  count = 3

  tags = {
    Name = "Public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "Private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  count = 3

  tags = {
    Name = "Private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = 3
  subnet_id      = aws_subnet.Public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id =  aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
  
}

resource "aws_route_table_association" "private" {
  count = 3
  subnet_id      = aws_subnet.Private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
    domain = "vpc"
  
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.Public[0].id

  tags = {
    Name = "${var.project}-ngw"
  }
}
