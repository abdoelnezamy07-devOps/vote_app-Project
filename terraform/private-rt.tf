resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vote-app.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf_nat.id
  }

  tags = {
    Name = "private-tf"
  }
}

resource "aws_route_table_association" "private-rt-association" {
  for_each       = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-rt.id
}