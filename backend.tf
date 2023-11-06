terraform {
  backend "s3" {
    bucket = "ateam-tf-states"
    key = "main"
    region = "us-east-1"
  }
}
