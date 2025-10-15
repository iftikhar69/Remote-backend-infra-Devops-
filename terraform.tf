terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-testing123-bucket"   # 🪣 backend bucket
    key            = "terraform.tfstate"             # state file
    region         = "ap-southeast-1"                # 🌏 your AWS region
    dynamodb_table = "terraform-state-table"         # 🧩 lock table
  }
}
