# app servers accept http only from the load balancer, not the internet
resource "aws_security_group_rule" "app_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.alb.id
}
