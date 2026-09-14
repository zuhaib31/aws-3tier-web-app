resource "aws_iam_role" "ec2_ssm" {
  name = "app-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Name = "app-ec2-ssm-role"
  }
}

# lets the ssm agent register + open sessions
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# instance profile = the holder that bolts the role onto ec2
resource "aws_iam_instance_profile" "app" {
  name = "app-ec2-profile"
  role = aws_iam_role.ec2_ssm.name
}
