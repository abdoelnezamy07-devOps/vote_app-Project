resource "aws_vpc" "vote-app" {
  cidr_block       = var.Cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}
