provider "aws" { 
  region = "us-east-2"
}



resource "aws_vpc" "practice-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: var.cidr_blocks[0].name,
    vpc_env: "dev"
  } 
} 

module "practice-subnet" {
  source = "./modules/subnet"
  cidr_blocks = var.cidr_blocks
  vpc_id = aws_vpc.practice-vpc.id
  default_route_table_id = aws_vpc.practice-vpc.default_route_table_id

}

module "practice-webserver" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.practice-vpc.id 
  image_name = var.image_name
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.practice-subnet.subnet.id
#   subnet_id = module.practice-subnet.subnet.id  \
  }