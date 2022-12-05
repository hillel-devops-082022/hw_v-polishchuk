# VPC and subnets
resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags       = var.tags
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.cidr_public
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.cidr_private

  tags = {
    Name = "private"
  }
}

# Internet and NAT gateways
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}
resource "aws_eip" "this" {
  vpc        = true

  depends_on = [aws_internet_gateway.this]
}
resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public.id

  depends_on    = [aws_eip.this]
}

# Route Table for Public Network
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "public"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Route Table for Private Network
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.default.id
  }
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Create security groups
resource "aws_security_group" "public" {
  vpc_id      = aws_vpc.this.id
  description = "Allow SSH inbound traffic"
  name        = "public"

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
}
resource "aws_security_group" "private" {
  vpc_id      = aws_vpc.this.id
  description = "Allow inbound traffic from public subnet"
  name        = "private"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}