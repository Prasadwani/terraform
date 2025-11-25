# variables.tf
# Terraform Variables for VPC Configuration

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "me-central-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for the VPC"
  type        = list(string)
}

variable "dhcp_domain_name" {
  description = "Domain name for DHCP options"
  type        = string
}

variable "dhcp_domain_name_servers" {
  description = "List of DNS servers for DHCP options"
  type        = list(string)
}

variable "dhcp_ntp_servers" {
  description = "List of NTP servers for DHCP options"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
    map_public_ip     = bool
  }))
}

variable "route_tables" {
  description = "Map of route table configuration"
  type = map(object({
    name               = string
    subnet_associations = list(string)  # List of subnet keys to associate
  }))
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
