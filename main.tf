# main.tf
# Main Terraform Configuration for VPC Setup

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Create VPC with primary CIDR block
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_blocks[0]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# Associate additional CIDR blocks to VPC
resource "aws_vpc_ipv4_cidr_block_association" "secondary" {
  count      = length(var.vpc_cidr_blocks) - 1
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_cidr_blocks[count.index + 1]
}

# Create DHCP Options Set
resource "aws_vpc_dhcp_options" "main" {
  domain_name          = var.dhcp_domain_name
  domain_name_servers  = var.dhcp_domain_name_servers
  ntp_servers          = var.dhcp_ntp_servers

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-DHCP-Options"
    }
  )
}

# Associate DHCP Options with VPC
resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}

# Create Internet Gateway for public subnets
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc_name}-igw"
    }
  )
}

# Create Subnets
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )

  depends_on = [
    aws_vpc_ipv4_cidr_block_association.secondary
  ]
}

# Create Route Tables
resource "aws_route_table" "route_tables" {
  for_each = var.route_tables

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

# Add default route to Internet Gateway for public route table
resource "aws_route" "public_internet_gateway" {
  for_each = {
    for k, v in var.route_tables : k => v
    if strcontains(lower(v.name), "public")
  }

  route_table_id         = aws_route_table.route_tables[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Create Route Table Associations
resource "aws_route_table_association" "associations" {
  for_each = {
    for pair in flatten([
      for rt_key, rt_value in var.route_tables : [
        for subnet_key in rt_value.subnet_associations : {
          rt_key     = rt_key
          subnet_key = subnet_key
          unique_key = "${rt_key}-${subnet_key}"
        }
      ]
    ]) : pair.unique_key => pair
  }

  subnet_id      = aws_subnet.subnets[each.value.subnet_key].id
  route_table_id = aws_route_table.route_tables[each.value.rt_key].id
}
