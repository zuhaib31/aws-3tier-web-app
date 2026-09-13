# app tier sg - inbound rules added when i build ec2
resource "aws_security_group" "app" {
  name        = "3tier-app-sg"
  description = "app tier"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3tier-app-sg"
  }
}

# db tier sg - only mysql from app tier, nothing else
resource "aws_security_group" "db" {
  name        = "3tier-db-sg"
  description = "db tier mysql from app only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3tier-db-sg"
  }
}
