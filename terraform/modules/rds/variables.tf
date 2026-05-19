variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
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

variable "tags" {
  type = map(string)
}