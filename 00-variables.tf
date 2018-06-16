provider "aws" {
  region = "us-east-1"
}

terraform {
  # Store Terraform state in S3, the bucket name is left out
  # so that it can be passed at initialization time. Variables
  # cannot be used here.
  backend "s3" {
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Use the S3 state
data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "hollowverse-terraform-state-${var.stage}"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

variable "stage" {
  type        = "string"
  default     = "development"
  description = "A separate copy of the infrastructure will be created for each stage"
}

locals {
  common_tags = {
    Terraform = "True"
    Stage     = "${var.stage}"
  }
}

locals {
  log_queue_name             = "logging-queue-${var.stage}"
  dead_letter_log_queue_name = "logging-dead-letter-queue-${var.stage}"
}
