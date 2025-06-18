data "aws_route53_zone" "main" {
  name         = "monarchfashion.click."
  private_zone = false
}

resource "aws_route53_record" "event_site" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "event.monarchfashion.click"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.event_site.domain_name
    zone_id                = aws_cloudfront_distribution.event_site.hosted_zone_id
    evaluate_target_health = false
  }
}
