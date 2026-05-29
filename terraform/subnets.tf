
resource "aws_subnet" "public_subnet"{
  vpc_id     = aws_vpc.vote-app.id
  for_each = var.public_sub
  cidr_block = cidrsubnet(var.Cidr_block,8,each.value) 
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "${each.key}_public_subnet"
  }
}
resource "aws_subnet" "private_subnet"{
  vpc_id     = aws_vpc.vote-app.id
  for_each = var.private_sub
  cidr_block = cidrsubnet(var.Cidr_block,8,each.value)  
  availability_zone = each.key
  tags = {
    Name = "${each.key}_private_subnet"
  }
}