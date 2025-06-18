resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "event-site-oac"
  description                       = "OAC for S3 static site"
  origin_access_control_origin_type  = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "event_site" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "NeoCloud Event Launch Site"
  default_root_object = "index.html"

  origin {
    domain_name = "neocloud-event-launch-monarchfashion-click.s3-website-us-east-1.amazonaws.com"
    origin_id   = "eventSiteS3Origin"
    # No OAI/OAC for website endpoint
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "eventSiteS3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  aliases = ["event.monarchfashion.click"]

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:631791546941:certificate/db2bb857-3038-4087-ba8b-193d3687d75c"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

 
}

