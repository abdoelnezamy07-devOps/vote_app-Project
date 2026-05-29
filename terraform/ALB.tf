resource "aws_lb" "ALB" {
  name               = "alb-cluster-tr"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALBSG.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id] ## its for var of subnets if created with (each_for)
  #subnets = aws_subnet.public_subnet[*].id ## its for var of subnets if created with (count)
}

output "alb-dns" {
  value = "nslookup ${aws_lb.ALB.dns_name}"
}