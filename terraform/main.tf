# Create remote state
terraform {
  backend "s3" {
    bucket = "django-sample-bucket"
    region = "us-east-1"
    key    = "prod/terraform.tfstate"
  }
}
