variable "cidr_blocks" {
  description = "cidr blocks and nametags for vpc & subnet"
  type = list(object({
    cidr_block = string,
    name = string
  }))
}
variable vpc_id {}
variable default_route_table_id {}