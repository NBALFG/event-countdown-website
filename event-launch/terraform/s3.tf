resource "aws_s3_bucket" "event_site" {
  bucket = "neocloud-event-launch-monarchfashion-click"
}


resource "aws_s3_bucket_website_configuration" "event_site_website" {
  bucket = aws_s3_bucket.event_site.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "event_site_policy" {
  bucket = aws_s3_bucket.event_site.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.event_site.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect = "Allow"
  }
}

resource "aws_s3_bucket_public_access_block" "event_site_block" {
  bucket = aws_s3_bucket.event_site.id
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.event_site.id
  key    = "index.html"
  source = "${path.module}/../index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.event_site.id
  key    = "style.css"
  source = "${path.module}/../style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "logo_png" {
  bucket = aws_s3_bucket.event_site.id
  key    = "neocloud-logo.png"
  source = "${path.module}/../neocloud-logo.png"
  content_type = "image/png"
}
