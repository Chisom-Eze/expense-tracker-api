terraform {
  backend "s3" {
    bucket         = "expense-tracker-tf-state-us-east-1"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "expense-tracker-tf-locks"
    encrypt        = true
  }
}