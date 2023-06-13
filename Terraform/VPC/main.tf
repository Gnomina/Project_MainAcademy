/*# AWS Init
provider "aws" {
  region = "${var.region}" 
}*/

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.VPC-CIDR}"  #VPS CIDR-Block

  tags = {
    //Name = var.VPC-Name #VPC Name
    Name = "${var.VPC-Name}"
  }
}

# Create Subnet in VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "${var.Subnet-CIDR}"  # subnet CIDR-Block

  tags = {
    Name = "${var.Subnet-Name}"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.IGW-Name}"
  }
}

# Create Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.RouteTable-Name}"
  }
}

# Create Route
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "${var.Destination-CIDR}"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create Route Table Association
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

output "vps" {
  value = "${aws_vpc.my_vpc.id}"
}