resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vote-app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub-tf"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public-rt.id
}