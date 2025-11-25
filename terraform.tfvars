# terraform.tfvars
# Actual values for SGAM-UAE VPC Configuration

region   = "me-central-1"
vpc_name = "SGAM-UAE-vpc"

vpc_cidr_blocks = [
  "172.20.96.0/21",
  "172.20.104.0/22",
  "172.20.108.0/22",
  "172.20.120.0/22"
]

dhcp_domain_name = "s2adv.com"
dhcp_domain_name_servers = [
  "10.0.0.101",
  "172.31.100.101"
]
dhcp_ntp_servers = [
  "10.0.0.101"
]

subnets = {
  public_1_az2 = {
    cidr_block        = "172.20.96.0/26"
    availability_zone = "me-central-1b"
    name              = "SGAM-UAE-Public1-AZ02-1b"
    map_public_ip     = true
  }
  security_private_1_az2 = {
    cidr_block        = "172.20.99.0/24"
    availability_zone = "me-central-1b"
    name              = "SGAM-UAE-Security-Subet-Private-1-AZ03-1b"
    map_public_ip     = false
  }
  trading_private_3_az2 = {
    cidr_block        = "172.20.120.0/24"
    availability_zone = "me-central-1b"
    name              = "SGAM-UAE-Trading-Subnet-Private-3-AZ02-1B"
    map_public_ip     = false
  }
  public_1_az3 = {
    cidr_block        = "172.20.100.0/26"
    availability_zone = "me-central-1c"
    name              = "SGAM-UAE-Public1-AZ03-1c"
    map_public_ip     = true
  }
  security_private_2_az3 = {
    cidr_block        = "172.20.103.0/24"
    availability_zone = "me-central-1c"
    name              = "SGAM-UAE-Security-Subnet-Private-2-AZ02-1c"
    map_public_ip     = false
  }
  trading_private_4_az3 = {
    cidr_block        = "172.20.123.0/24"
    availability_zone = "me-central-1c"
    name              = "SGAM-UAE-Trading-subnet-Private-4-AZ03-1C"
    map_public_ip     = false
  }
}

route_tables = {
  public = {
    name = "SGAM-UAE-rtb-public"
    subnet_associations = [
      "public_1_az2",
      "public_1_az3"
    ]
  }
  private_1_az2 = {
    name = "SGAM-UAE-rtb-private-1-me-central-1b"
    subnet_associations = [
      "security_private_1_az2"
    ]
  }
  private_3_az2 = {
    name = "SGAM-UAE-rtb-private-3-me-central-1b"
    subnet_associations = [
      "trading_private_3_az2"
    ]
  }
  private_4_az3 = {
    name = "SGAM-UAE-rtb-private-4-me-central-1C"
    subnet_associations = [
      "trading_private_4_az3"
    ]
  }
  private_2_az3 = {
    name = "SGAM-UAE-rtb-private-2-me-central-1c"
    subnet_associations = [
      "security_private_2_az3"
    ]
  }
}

tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Project     = "SGAM-UAE"
}
