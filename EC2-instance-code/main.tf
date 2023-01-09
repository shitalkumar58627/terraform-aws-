terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

 # Configure the AWS Provider
provider "aws" {
  region = var.region
  profile = var.profile_name
}

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "app-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_instance" "web" {
  ami           = "ami-052efd3df9dad4825" 
  instance_type = var.instance_type
  key_name = var.instance_key
  subnet_id              = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.sg.id]

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  sudo rm -rf /var/www/html/index.html
  sudo apt install unzip && apt install wget -y 
  sudo wget https://www.free-css.com/assets/files/free-css-templates/download/page276/transportz.zip && unzip transportz.zip
  sudo mv transportz/* /var/www/html 
  sudo systemctl restart apache2 
  echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name = "web_instance"
  }

  volume_tags = {
    Name = "web_instance"
  } 
}


resource "aws_key_pair" "news-pair" {
  key_name   = "news-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCLRViomxZi/wTgxkrkYqk9xSs4CEEyNYkxLZWXHrL/1ksG52h8UJ/WrDBdW2v7gMSaIqK8NE1idyokPSX25n5AMYIbHVZEyfPk8d0RAVIZbhZMtYE4GwamyFazKvT15PHk+h9X2PxumaEgvO65NdvGfx4+vyGK8VmmecByGweM7Hg8Hj8sfdYoMiGqxOTscziJQYuuJYVKP9uGh4OQVtG1LLYL8W99oloCbJLgRn9PzBic8iJS4qDDVR4UGzef5ot5F8Bcu+gOZyQsK9YFTAfJgQfBWKIcYnNJWk8BoA0I1cUsCmWjZ9+2zlXAhMLBvjm9Isb67strmOoUx8OocSHt rsa-key-20220704"
}

