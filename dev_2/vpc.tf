# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "vook_rails_1_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true # DNSホスト名を有効化
  tags = {
    Name = "vook-rails-1-vpc"
  }
}

# ---------------------------
# Subnet
# ---------------------------
resource "aws_subnet" "vook_rails_1_public_subnet_1a" {
  vpc_id            = aws_vpc.vook_rails_1_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.az_a

  tags = {
    Name = "vook-rails-1-public-subnet-1a"
  }
}

resource "aws_subnet" "vook_rails_1_private_subnet_1a" {
  vpc_id            = aws_vpc.vook_rails_1_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = var.az_a

  tags = {
    Name = "vook-rails-1-private-subnet-1a"
  }
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "vook_rails_1_igw" {
  vpc_id = aws_vpc.vook_rails_1_vpc.id
  tags = {
    Name = "vook-rails-1-igw"
  }
}

# ---------------------------
# Route table
# ---------------------------
# Route table作成 public
resource "aws_route_table" "vook_rails_1_public_route" {
  vpc_id = aws_vpc.vook_rails_1_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vook_rails_1_igw.id
  }
  tags = {
    Name = "vook-rails-1-public-route"
  }
}

# SubnetとRoute tableの関連付け public
resource "aws_route_table_association" "vook_rails_1_public_route" {
  subnet_id      = aws_subnet.vook_rails_1_public_subnet_1a.id
  route_table_id = aws_route_table.vook_rails_1_public_route.id
}

# Route table作成 private
resource "aws_route_table" "vook_rails_1_private_route" {
  vpc_id = aws_vpc.vook_rails_1_vpc.id
  tags = {
    Name = "vook-rails-1-private-route"
  }
}

# SubnetとRoute tableの関連付け private
resource "aws_route_table_association" "vook_rails_1_private_route" {
  subnet_id      = aws_subnet.vook_rails_1_private_subnet_1a.id
  route_table_id = aws_route_table.vook_rails_1_private_route.id
}

# ---------------------------
# Security Group
# ---------------------------
# 自分のパブリックIP取得
data "http" "ifconfig" {
  url = "http://ipv4.icanhazip.com/"
}

variable "allowed_cidr" {
  description = "CIDR block for allowed IP addresses"
  type        = string
  default     = "0.0.0.0/0"
}

locals {
  myip         = chomp(data.http.ifconfig.body)
  allowed_cidr = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
}

# Security Group作成
resource "aws_security_group" "vook_rails_1_sg" {
  name        = "vook-rails-1-sg"
  description = "For EC2 Linux"
  vpc_id      = aws_vpc.vook_rails_1_vpc.id
  tags = {
    Name = "vook-rails-1-sg"
  }

  # インバウンドルール
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
