variable "name_prefix" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "alb_security_group_id" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "target_group_arn" {
  type        = string
}


variable "execution_role_arn" {
  type        = string
}

variable "task_role_arn" {
  type        = string
}

variable "container_image" {
  type        = string
}

variable "database_url_secret_arn" {
  type        = string
}

variable "secret_key_secret_arn" {
  type        = string
}

variable "tags" {
  type        = map(string)
}
