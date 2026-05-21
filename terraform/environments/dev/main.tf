module "ecr" {
  source = "../../modules/ecr"

 name_prefix = local.name_prefix
    tags = local.common_tags
}


module "networking" {
  source = "../../modules/networking"

    tags = local.common_tags
}


module "alb" {
  source = "../../modules/alb"

  name_prefix = local.name_prefix
  vpc_id      = module.networking.vpc_id
  subnet_ids  = module.networking.subnet_ids
  certificate_arn = module.dns.validated_certificate_arn
  tags = local.common_tags
}


module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}


module "secrets" {
  source = "../../modules/secrets"

  name_prefix   = local.name_prefix
  
  database_url  = var.database_url
  secret_key    = var.secret_key

  tags = local.common_tags
}


module "ecs" {
  source = "../../modules/ecs"

  name_prefix = local.name_prefix
  aws_region  = var.aws_region

  vpc_id      = module.networking.vpc_id
  subnet_ids  = module.networking.subnet_ids

  target_group_arn = module.alb.target_group_arn
  alb_security_group_id = module.alb.security_group_id

  container_image = var.container_image

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn

  database_url_secret_arn = module.secrets.database_url_secret_arn
  secret_key_secret_arn   = module.secrets.secret_key_secret_arn

  depends_on = [module.alb]

  tags = local.common_tags
}

module "rds" {
  source = "../../modules/rds"
  name_prefix     = local.name_prefix

  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.subnet_ids

  ecs_security_group_id = module.ecs.ecs_security_group_id

  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password

  tags = local.common_tags
}


module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix   = local.name_prefix

  cluster_name  = module.ecs.cluster_name
  service_name  = module.ecs.service_name
}

module "backend" {
  source = "../../modules/backend"

  bucket_name     = "expense-tracker-tf-state-${var.aws_region}"
  lock_table_name = "expense-tracker-tf-locks"

  tags            = local.common_tags
}

module "acm" {
  source = "../../modules/acm"

  domain_name = var.domain_name

  tags = local.common_tags
}

module "dns" {
  source = "../../modules/dns"

  domain_name = var.domain_name
  subdomain = var.subdomain

  certificate_arn = module.acm.certificate_arn

  domain_validation_options = module.acm.domain_validation_options

 alb_dns_name = module.alb.alb_dns_name
 alb_zone_id = module.alb.alb_zone_id

  tags = local.common_tags
}