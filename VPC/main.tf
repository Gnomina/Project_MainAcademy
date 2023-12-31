# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.VPC_cidr_block}"  #VPC CIDR-Block

  tags = {
      Name = "${var.Name_VPC}"
  }
}

# Create Subnet in VPC
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "${var.subnet_cidr_block}"  # subnet CIDR-Block

  tags = {
    Name = "${var.Name_subnet}"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.Name_InternetGateway}"
  }
}

# Create Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.Name_RouteTable}"
  }
}

# Create Route
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "${var.route_destination_cidr_block}"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create Route Table Association
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}
