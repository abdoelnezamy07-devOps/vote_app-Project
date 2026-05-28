resource "aws_nat_gateway" "tf_nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public_subnet["us-east-1a"].id

  tags = {
    Name = "tf-gw_NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip_nat" {
  domain = "vpc"
}