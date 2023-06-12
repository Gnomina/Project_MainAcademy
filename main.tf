# Инициализация провайдера AWS
provider "aws" {
  region = "eu-central-1"  # Замените на вашу желаемую AWS-регион
}

# Создание VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Замените на подходящий CIDR-блок для вашей сети

  tags = {
    Name = "MyVPC_TesT"
  }
}

# Создание Subnet внутри VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Замените на подходящий CIDR-блок для вашего subnet

  tags = {
    Name = "MySubnet_TesT"
  }
}

# Создание интернет-шлюза
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyIGW_TesT"
  }
}

# Создание маршрутной таблицы
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyRouteTable_Test"
  }
}

# Создание маршрута для интернет-шлюза
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Присоединение Subnet к маршрутной таблице
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}
