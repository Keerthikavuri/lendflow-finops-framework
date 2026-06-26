# ============================================================
# LendFlow Technologies — Cost-Aware EC2 Terraform Module
# File: policies/terraform-cost-aware-module.tf
# Purpose: Enforce mandatory tags, instance size limits,
#          and cost-aware validation at IaC level
# ============================================================

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ============================================================
# VARIABLES WITH VALIDATION
# ============================================================

variable "instance_type" {
  description = "EC2 instance type — validated against approved list per environment"
  type        = string

  validation {
    condition = !contains([
      "p2.xlarge", "p2.8xlarge", "p2.16xlarge",
      "p3.2xlarge", "p3.8xlarge", "p3.16xlarge",
      "p4d.24xlarge", "p4de.24xlarge",
      "g4dn.12xlarge", "g4dn.metal",
      "g5.48xlarge", "g5.12xlarge"
    ], var.instance_type)
    error_message = "GPU instances require explicit FinOps approval. Contact finops@lendflow.com."
  }

  validation {
    condition = !endswith(var.instance_type, ".metal")
    error_message = "Bare metal instances require CTO approval. Contact finops@lendflow.com."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["production", "staging", "development", "sandbox"], var.environment)
    error_message = "environment must be one of: production, staging, development, sandbox."
  }
}

variable "mandatory_tags" {
  description = "Mandatory cost allocation tags — all 5 required"
  type = object({
    business_unit = string
    product       = string
    environment   = string
    cost_centre   = string
    team          = string
  })

  validation {
    condition     = contains(["lending", "payments", "insurance", "platform", "shared"], var.mandatory_tags.business_unit)
    error_message = "business_unit must be one of: lending, payments, insurance, platform, shared."
  }

  validation {
    condition     = contains(["production", "staging", "development", "sandbox"], var.mandatory_tags.environment)
    error_message = "Tag environment must be one of: production, staging, development, sandbox."
  }

  validation {
    condition     = can(regex("^CC-[0-9]{4}$", var.mandatory_tags.cost_centre))
    error_message = "cost_centre must follow format CC-XXXX (e.g., CC-1001)."
  }
}

variable "optional_tags" {
  description = "Optional additional tags"
  type        = map(string)
  default     = {}
}

variable "ttl" {
  description = "Time-to-live for temporary resources (YYYY-MM-DD or 'permanent')"
  type        = string
  default     = "permanent"

  validation {
    condition     = var.ttl == "permanent" || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", var.ttl))
    error_message = "ttl must be 'permanent' or a date in YYYY-MM-DD format."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

# ============================================================
# LOCAL VALUES
# ============================================================

locals {
  # Approved instance types per environment
  dev_approved_types = [
    "t3.small", "t3.medium", "t3.large",
    "m5.large", "m5.xlarge",
    "c5.large", "c5.xlarge"
  ]

  prod_approved_types = [
    "m5.large", "m5.xlarge", "m5.2xlarge", "m5.4xlarge",
    "c5.large", "c5.xlarge", "c5.2xlarge", "c5.4xlarge",
    "r5.large", "r5.xlarge", "r5.2xlarge",
    "m6g.large", "m6g.xlarge", "m6g.2xlarge",
    "c6g.large", "c6g.xlarge", "c6g.2xlarge"
  ]

  # Merge all tags
  all_tags = merge(
    var.mandatory_tags,
    var.optional_tags,
    {
      ttl        = var.ttl
      created_by = "terraform"
      managed_by = "lendflow-platform-team"
    }
  )
}

# ============================================================
# EC2 INSTANCE RESOURCE
# ============================================================

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  tags = local.all_tags

  lifecycle {
    precondition {
      condition = (
        var.environment != "development" ||
        contains(local.dev_approved_types, var.instance_type)
      )
      error_message = "Development environment only allows: ${join(", ", local.dev_approved_types)}. Use approved types or request exception from FinOps team."
    }
  }
}

# ============================================================
# OUTPUTS
# ============================================================

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "instance_type" {
  description = "EC2 instance type deployed"
  value       = aws_instance.this.instance_type
}

output "tags_applied" {
  description = "All tags applied to the instance"
  value       = aws_instance.this.tags_all
}

output "monthly_cost_estimate" {
  description = "Estimated monthly cost (reference only — verify with AWS Pricing Calculator)"
  value = {
    "t3.small"   = "$15/month"
    "t3.medium"  = "$30/month"
    "t3.large"   = "$60/month"
    "m5.large"   = "$70/month"
    "m5.xlarge"  = "$140/month"
    "m5.2xlarge" = "$280/month"
    "c5.large"   = "$61/month"
    "c5.xlarge"  = "$122/month"
  }[var.instance_type]
}