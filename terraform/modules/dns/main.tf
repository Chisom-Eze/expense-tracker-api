resource "aws_route53_zone" "main" {
    name = var.domain_name
}


resource "aws_route53_record" "cert_validattion" {
   for_each = {
      for dvo in var.domain_validation_options :
      dvo.domain_name => {
         name = dvo.resource_record_name
         type = dvo.resource_record_type
         records = dvo.resource_record_value
      }
   }
   zone_id = aws_route53_zone.main.zone_id

   name = each.value.name
   type = each.value.type
   ttl = 60
   records = [each.value.records]
}

resource "aws_acm_certificate_validation" "api_cert_validation" {
   certificate_arn = var.certificate_arn

   validation_record_fqdns = [
      for record in aws_route53_record.cert_validattion :
      record.fqdn
   ]
 
}

resource "aws_route53_record" "api_alias" {
  zone_id = aws_route53_zone.main.zone_id

  name = var.subdomain
  type = "A"

   alias {
      name = var.alb_dns_name
      zone_id = var.alb_zone_id
      evaluate_target_health = true
   }
}