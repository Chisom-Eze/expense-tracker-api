variable "name_prefix" {
  type        = string
}


variable "database_url" {
  type        = string
}

variable "secret_key" {
  type        = string
}

variable "tags" {
  type        = map(string)
}