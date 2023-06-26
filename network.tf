# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   # enable_dns_hostnames = true
#   tags = {
#     Name = "chikami-tf-vpc"
#   }
# }

# resource "aws_subnet" "main" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "chikami-tf-sub"
#   }
# }

resource "aws_vpc" "tf-vpc" {
   cidr_block = var.cidr_block
  tags = {
    "Name" = "${var.Name}-tf-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.tf-vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "chikami-tf-sub"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "chikami-tf-igw"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = {
    Name = "chikami-tf-rtb"
  }
}

resource "aws_route_table_association" "qiita_rtb_assoc_pblic" {
  route_table_id = aws_route_table.example.id
  subnet_id      = aws_subnet.main.id
}