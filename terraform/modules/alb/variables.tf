variable "name_prefix" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "tags" {
  type        = map(string)
}

variable "certificate_arn" {
  type        = string
}
