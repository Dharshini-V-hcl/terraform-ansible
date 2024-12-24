terraform {
  backend "s3" {
    bucket         = "terrastate-file-learning"
    key            = "ansible/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-learning"
    encrypt        = true
  }
}
