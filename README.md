# ⚙️ Terraform Remote Backend — S3 + DynamoDB

## Overview
This repository configures a **remote backend** for Terraform using **Amazon S3** and **DynamoDB**. The S3 bucket stores the Terraform state file, while the DynamoDB table manages state locking. This setup ensures that only one operation can modify the infrastructure at a time, maintaining consistency and preventing state corruption.

---

## How It Works
- 🪣 **S3 Bucket:** Stores the `terraform.tfstate` file safely and centrally for all users or CI/CD pipelines.  
- 🧩 **DynamoDB Table:** Uses a `LockID` attribute to track and control concurrent Terraform operations.  
- When a `terraform apply` or `plan` command runs, Terraform acquires a lock in DynamoDB.  
- If another process tries to run Terraform simultaneously, it receives a lock error until the current operation completes.  
- Once finished, the lock is automatically released.

---

## Backend Configuration Example
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-testing123-bucket"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-table"
  }
}

| Resource              | Example Name                  | Purpose                         |
| --------------------- | ----------------------------- | ------------------------------- |
| 🪣 **S3 Bucket**      | `terraform-testing123-bucket` | Stores Terraform state remotely |
| 🧩 **DynamoDB Table** | `terraform-state-table`       | Manages Terraform state locks   |

Usage
Initialize the Backend
terraform init -reconfigure

Review Planned Changes
terraform plan

Apply Infrastructure Changes
terraform apply

Destroy Infrastructure
terraform destroy

Refresh or Migrate State (Optional)
terraform refresh
terraform init -migrate-state

Locking Behavior

If one user runs:
terraform apply

and another runs:
terraform plan

The second user will see:
Error: Error acquiring the state lock

This indicates the DynamoDB lock is active, preventing concurrent changes. The lock automatically clears when the operation completes.

Verification

Check that your resources exist and the state is stored remotely:
aws s3 ls --region ap-southeast-1
aws dynamodb list-tables --region ap-southeast-1
aws s3 ls s3://terraform-testing123-bucket --region ap-southeast-1

Author

Iftikhar
DevOps Engineer — AWS | Terraform | Infrastructure as Code (IaC)
