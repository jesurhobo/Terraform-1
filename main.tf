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

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}