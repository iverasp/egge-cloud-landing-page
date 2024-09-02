resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "content" {
  bucket = "landing-page-content-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_acl" "content_acl" {
  bucket     = aws_s3_bucket.content.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.content.id
  rule {
    object_ownership = "ObjectWriter"
  }
}


resource "aws_s3_bucket_website_configuration" "website_conf" {
  bucket = aws_s3_bucket.content.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.content.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "AllowPublic"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.content.arn}/**"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.content.bucket
  key          = "index.html"
  source       = "../index.html"
  content_type = "text/html"
}