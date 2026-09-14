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

resource "aws_launch_template" "app" {
  name_prefix   = "3tier-app-"
  image_id      = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", {
    db_host     = aws_db_instance.main.address
    secret_arn  = aws_db_instance.main.master_user_secret[0].secret_arn
    bucket_name = aws_s3_bucket.assets.bucket
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "3tier-app-server"
    }
  }
}
