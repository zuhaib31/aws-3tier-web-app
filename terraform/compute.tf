data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.app_a.id
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.app.name

  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    db_host    = aws_db_instance.main.address
    secret_arn = aws_db_instance.main.master_user_secret[0].secret_arn
  })
  user_data_replace_on_change = true

  depends_on = [aws_vpc_endpoint.secretsmanager]

  tags = {
    Name = "3tier-app-server"
  }
}
