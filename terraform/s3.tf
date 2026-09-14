resource "aws_s3_bucket" "assets" {
  bucket = "zohaib-3tier-assets-438465152731"

  tags = {
    Name = "3tier-assets"
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "message" {
  bucket       = aws_s3_bucket.assets.id
  key          = "message.txt"
  content      = "Hello from S3 - this text lives in an S3 bucket and is loaded by the app at boot."
  content_type = "text/plain"
}

# app role may read only this bucket
resource "aws_iam_role_policy" "s3_read" {
  name = "read-assets-bucket"
  role = aws_iam_role.ec2_ssm.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.assets.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.assets.arn
      }
    ]
  })
}
