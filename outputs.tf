# outputs.tf
# Terraform Outputs

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_blocks" {
  description = "CIDR blocks of the VPC"
  value       = concat([aws_vpc.main.cidr_block], aws_vpc_ipv4_cidr_block_association.secondary[*].cidr_block)
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "dhcp_options_id" {
  description = "ID of the DHCP Options Set"
  value       = aws_vpc_dhcp_options.main.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value = {
    for k, v in aws_subnet.subnets : k => v.id
  }
}

output "subnet_details" {
  description = "Detailed information about all subnets"
  value = {
    for k, v in aws_subnet.subnets : k => {
      id                = v.id
      arn               = v.arn
      cidr_block        = v.cidr_block
      availability_zone = v.availability_zone
    }
  }
}

output "route_table_ids" {
  description = "Map of route table names to IDs"
  value = {
    for k, v in aws_route_table.route_tables : k => v.id
  }
}

output "route_table_details" {
  description = "Detailed information about all route tables"
  value = {
    for k, v in aws_route_table.route_tables : k => {
      id  = v.id
      arn = v.arn
    }
  }
}
