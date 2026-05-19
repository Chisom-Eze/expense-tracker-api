variable domain_name {
  type        = string
}

variable subdomain {
  type        = string
}

variable certificate_arn {
  type        = string
}

variable alb_dns_name {
  type        = string
}

variable alb_zone_id {
  type        = string
}

variable "domain_validation_options" {}

variable "tags" {
  type        = map(string)
}
