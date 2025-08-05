terraform {
  backend "s3" {
    bucket = "jenkinstask-2"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}