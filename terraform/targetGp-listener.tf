resource "aws_lb_target_group" "alb-TG" {
  name        = "TG-Cluster-tf"
  target_type = "instance"
  port        = "32000"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vote-app.id
}

resource "aws_lb_listener" "vote" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-TG.arn
  }
}

resource "aws_lb_target_group_attachment" "k8s-target" {
  for_each = aws_instance.workers
  target_group_arn = aws_lb_target_group.alb-TG.arn
  target_id        = each.value.id
  port             = 32000
}
