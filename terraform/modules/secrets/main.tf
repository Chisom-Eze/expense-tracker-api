resource "aws_secretsmanager_secret" "database_url" {
  name = "${var.name_prefix}-database-url"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "database_url" {
  secret_id     = aws_secretsmanager_secret.database_url.id
  secret_string = var.database_url
}

resource "aws_secretsmanager_secret" "secret_key" {
  name = "${var.name_prefix}-secret-key"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "secret_key" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = var.secret_key
}