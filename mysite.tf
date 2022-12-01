# terraform init
# terraform plan
# terraform apply
# terraform destroy

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.41.0"
    }
  }
}

provider "aws" {
  # Configuration options
    region = "us-east-1"

}

# # creating vpc
# resource "aws_vpc" "tech365vpc" {
#   cidr_block = var.cidr_block[0]

#   tags = {
#     Name = "tech365vpc"
#   }
# }

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# # creating subnet
# resource "aws_subnet" "main" {
#   vpc_id     = aws_vpc.main.vpc-03f7b592376db96d9
#   cidr_block = var.cidr_block[0]

#   tags = {
#     Name = "Main"
#   }
# }

# provisioing EC2
resource "aws_instance" "apachesite" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = "techtee"
  # subnet_id = aws_subnet.tech365subnet.id
  vpc_security_group_ids = [aws_security_group.tech365_sg.id]
  associate_public_ip_address = true
  user_data = "${file("./mysite.sh")}"

  tags = {
    Name = "apachesite"
  }
}

# security group
resource "aws_security_group" "tech365_sg" {
  name        = "tech365_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-03f7b592376db96d9"

  dynamic ingress {
    iterator = port
    for_each = var.ports
    content{
        from_port = port.value
        to_port = port.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    # from_port        = 22
    # to_port          = 22
    # protocol         = "tcp"
    # cidr_blocks      = ["0.0.0.0/0"]
    # cidr_blocks      = [aws_vpc.main.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}