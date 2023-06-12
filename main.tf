# Инициализация провайдера AWS
provider "aws" {
  region = "eu-central-1"  # Замените на вашу желаемую AWS-регион
}

# Создание VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Замените на подходящий CIDR-блок для вашей сети

  tags = {
    Name = "MyVPC_1"
  }
}

# Создание Subnet внутри VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Замените на подходящий CIDR-блок для вашего subnet

  tags = {
    Name = "MySubnet_1"
  }
}
