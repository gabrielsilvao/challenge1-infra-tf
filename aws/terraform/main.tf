data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-main"
  }
}

locals {
  total_subnets = var.public_subnet_count + var.private_subnet_count
  azs           = data.aws_availability_zones.available.names
  vpc_prefix    = tonumber(split("/", var.vpc_cidr)[1])
  newbits       = var.subnet_prefix_length - local.vpc_prefix
  subnet_cidrs  = [for i in range(local.total_subnets) : cidrsubnet(var.vpc_cidr, local.newbits, i)]
}

resource "aws_subnet" "this" {
  count                   = local.total_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnet_cidrs[count.index]
  availability_zone       = local.azs[count.index % length(local.azs)]
  map_public_ip_on_launch = count.index < var.public_subnet_count ? true : false

  tags = {
    Name = count.index < var.public_subnet_count ? "public-${count.index + 1}" : "private-${count.index - var.public_subnet_count + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-public"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.public.id
}

# Single EIP + NAT Gateway (placed in the first public subnet)
resource "aws_eip" "nat" {
  tags = {
    Name = "nat-eip"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.this[0].id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "nat-gw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "rt-private"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.this[var.public_subnet_count + count.index].id
  route_table_id = aws_route_table.private.id
}
