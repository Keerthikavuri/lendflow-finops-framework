# Day 12 — Policy-as-Code & Automation
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Full Day — Policy-as-Code Implementation

### SCP Policies Designed (4 Policies)

**Policy 1: Mandatory Tagging Enforcement**
- Denies creation of EC2, RDS, S3, EBS without all 5 mandatory tags
- Applied at AWS Organisation level
- File: policies/scp-mandatory-tagging.json

**Policy 2: GPU Instance Launch Restrictions**
- Denies launch of p3, p4, g4, g5 instance families without explicit approval tag
- Limited to specific ML training account only
- File: policies/scp-gpu-restrictions.json

**Policy 3: Region Restrictions**
- Denies resource creation outside ap-south-1 (Mumbai) and us-east-1
- Exception: GDPR-compliant EU workloads permitted in eu-west-1
- File: policies/scp-region-restrictions.json

**Policy 4: Maximum Instance Count Limits**
- Denies Auto Scaling Group creation with max_capacity > 100
- Prevents runaway scaling events like $2.4M billing shock case study
- File: policies/scp-instance-count-limits.json

### AWS Config Rules Designed

| Rule Name | Evaluation | Trigger | Remediation |
|---|---|---|---|
| REQUIRED_TAGS | All taggable resources have 5 mandatory tags | Configuration change | Lambda: auto-tag + Slack alert |
| EC2_LOW_UTILISATION | EC2 instances <20% CPU for 30+ days | Periodic (daily) | Dashboard flag + JIRA ticket |
| S3_STANDARD_AGED_DATA | S3 objects in Standard tier, not accessed 90+ days | Periodic (weekly) | Notification to data owner |
| EBS_UNATTACHED_VOLUMES | EBS volumes unattached for 7+ days | Configuration change | Slack alert + auto-snapshot + delete after 14 days |
| SECURITY_GROUP_OPEN | Security groups with 0.0.0.0/0 on non-80/443 ports | Configuration change | Alert to security team |

### Automated Remediation Workflow Design

Trigger: AWS Config Rule violation detected

↓

Lambda Function: finops-auto-remediation

↓

├── Action 1: Apply default tags to non-compliant resource

│   └── Tags: environment=unknown, team=unassigned, cost_centre=CC-0000

↓

├── Action 2: Send Slack notification

│   └── Channel: #finops-alerts

│   └── Message: Resource [ID] missing tags. Default tags applied. Owner: [IAM user]

↓

├── Action 3: Create JIRA ticket

│   └── Project: FINOPS

│   └── Priority: Medium

│   └── Assignee: [Team lead based on IAM user lookup]

↓

└── Action 4: Log to DynamoDB

└── Table: finops-compliance-events

└── Fields: resource_id, violation_type, timestamp, remediation_action, status

### Terraform Module Template Design

```hcl
# modules/cost-aware-ec2/variables.tf

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  
  validation {
    # Block oversized instances in non-production
    condition = !(var.environment != "production" && 
                  contains(["m5.4xlarge","m5.8xlarge","c5.4xlarge","r5.4xlarge"], 
                  var.instance_type))
    error_message = "Instance types larger than xlarge not allowed in non-production environments."
  }
}

variable "business_unit" {
  description = "Business unit tag - mandatory"
  type        = string
  validation {
    condition     = contains(["lending", "payments", "platform", "shared"], var.business_unit)
    error_message = "business_unit must be one of: lending, payments, platform, shared"
  }
}

variable "environment" {
  description = "Deployment environment - mandatory"
  type        = string
  validation {
    condition     = contains(["production", "staging", "development", "sandbox"], var.environment)
    error_message = "environment must be one of: production, staging, development, sandbox"
  }
}

variable "cost_centre" {
  description = "Financial cost centre code - mandatory"
  type        = string
  validation {
    condition     = can(regex("^CC-[0-9]{4}$", var.cost_centre))
    error_message = "cost_centre must match format CC-XXXX (e.g., CC-1001)"
  }
}

variable "team" {
  description = "Owning engineering team - mandatory"
  type        = string
}
```

### Infracost Integration Design
- Pre-commit hook runs `infracost breakdown` on every Terraform plan
- PR comment added with cost impact: "+$240/month for this change"
- CI/CD pipeline fails if Terraform plan increases cost by >$500/month without FinOps Lead approval
- Cost diff tracked in CHANGELOG for every infrastructure change

---

## Key Learnings Today
1. SCPs are the only reliable preventive control — they cannot be overridden by member accounts
2. Terraform validation blocks stop oversized instances before they reach cloud — shift-left cost governance
3. Infracost in CI/CD pipeline creates developer cost awareness without manual process
4. Auto-remediation must log everything to DynamoDB — audit trail required for SOC 2

---

## Tomorrow's Plan
- Create CFO Review Panel presentation (18 slides)
- Prepare detailed speaker notes with anticipated Q&A
- Design 90-day implementation Gantt chart