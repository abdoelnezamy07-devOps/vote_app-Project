resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vote-app.id

  tags = {
    Name = "igw-tr"
  }
}