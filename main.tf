provider "aws" { 
  region = "us-east-2"
}

variable "cidr_blocks" {
  description = "cidr blocks and nametags for vpc & subnet"
  type = list(object({
    cidr_block = string,
    name = string
  }))
}
variable my_ip {}
variable instance_type {}
variable public_key_location {}


resource "aws_vpc" "practice-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: var.cidr_blocks[0].name,
    vpc_env: "dev"
  } 
} 

resource "aws_subnet" "practice-subnet" {
    vpc_id = aws_vpc.practice-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "us-east-2c"
    tags = {
        Name: var.cidr_blocks[1].name
  }

}

resource "aws_internet_gateway" "practice-igw" {
  vpc_id = aws_vpc.practice-vpc.id

  tags = {
    Name = "practice-igw"
  }
}

resource "aws_default_route_table" "main-rt" {
    default_route_table_id = aws_vpc.practice-vpc.default_route_table_id

    route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.practice-igw.id
   }
    tags = { 
        Name: "default-rt"
    }
     }

resource "aws_security_group" "practice-sg" {
  name        = "practice-sg"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.practice-vpc.id

  ingress {
    description   = "SSH"
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 8080
    to_port       = 8080
    protocol      = "tcp"
    cidr_blocks    = ["0.0.0.0/0"]
  }

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "practice-sg"
  }
} 

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_public_ip" {
  value = aws_instance.practice-server.public_ip
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "practice-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.practice-subnet.id
  vpc_security_group_ids = [aws_security_group.practice-sg.id]
  availability_zone = "us-east-2c"

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")
#   user_data = <<EOF
#   #!/bin/bash
# sudo yum update -y 
# sudo yum install -y docker
# sudo systemctl start docker
# sudo usermod -aG docker ec2-user
# docker run -p 8080:80 nginx
# EOF


  tags = {
    Name = "practice-server"
  }

}
output "user_data_script" {
  value = aws_instance.practice-server.user_data
}
