provider "aws" {
  region = "eu-central-1" 
}


/*
module "VPC" {
  source = "./Terraform/VPC"
} 
*/   

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  #VPS CIDR-Block

  tags = {
      Name = "MainAcademy_VPC"
  }
}

# Create Subnet in VPC
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"  # subnet CIDR-Block

  tags = {
    Name = "MainAcademy_Subnet"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MainAcademy_IGW"
  }
}

# Create Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MainAcademy_RouteTable"
  }
}

# Create Route
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create Route Table Association
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}


output "vpc_id" {
  value = aws_vpc.my_vpc.id
}