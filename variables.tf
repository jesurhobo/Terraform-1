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
variable image_name {}
variable subnet_id {}
