variable "project_name" {
    default = "expense-tracker"
}

variable environment {
  type        = string
}

variable aws_region {
  type        = string
  default     = "us-east-1"
}



variable "container_image" {
  default = "625444834398.dkr.ecr.us-east-1.amazonaws.com/expense-tracker:stable"
}

variable "secret_key" {
 sensitive = true
}

variable "database_url" {
  sensitive = true
}

variable "db_name" {
  type = string
}

variable "db_username" {
  sensitive = true
}

variable "db_password" {
  sensitive = true
}

variable "domain_name" {}

variable "subdomain" {}
