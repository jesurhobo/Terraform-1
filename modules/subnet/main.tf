resource "aws_subnet" "practice-subnet" {
    # vpc_id = aws_vpc.practice-vpc.id
    vpc_id = var.vpc_id

    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "us-east-2c"
    tags = {
        Name: var.cidr_blocks[1].name
  }

}

resource "aws_internet_gateway" "practice-igw" {
#   vpc_id = aws_vpc.practice-vpc.id
    vpc_id = var.vpc_id


  tags = {
    Name = "practice-igw"
  }
}

resource "aws_default_route_table" "main-rt" {
    # default_route_table_id = aws_vpc.practice-vpc.default_route_table_id
    default_route_table_id = var.default_route_table_id


    route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.practice-igw.id
   }
    tags = { 
        Name: "default-rt"
    }
     }
