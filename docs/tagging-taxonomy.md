# Cost Allocation Tagging Taxonomy — LendFlow Technologies
**Prepared by:** Sai Keerthi Kavuri, FinOps Engineer  
**Date:** June 2026

---

## Overview

This document defines the mandatory cost allocation tagging taxonomy for LendFlow Technologies. Current tag compliance is 34% — meaning 66% of cloud spend is unattributable to any business unit, product, or team. This taxonomy, enforced through AWS Service Control Policies (SCPs), AWS Config Rules, and automated Lambda remediation, targets 95%+ compliance within 90 days.

**Current State:** 34% compliance — $48,000/month dark spend  
**Target State:** 95%+ compliance — full cost attribution across all resources

---

## Mandatory Tag Schema

### Tag 1: business_unit
| Attribute | Value |
|---|---|
| Description | Top-level organisational division owning the resource |
| Required | Yes — SCP blocks resource creation without this tag |
| Allowed Values | lending, payments, insurance, platform, shared |
| Example | business_unit = lending |
| Enforcement | SCP: Deny if missing |

### Tag 2: product
| Attribute | Value |
|---|---|
| Description | Specific product or service line |
| Required | Yes — SCP blocks resource creation without this tag |
| Allowed Values | personal_loans, merchant_lending, credit_line, payment_gateway, fraud_detection, platform_infra, data_platform |
| Example | product = personal_loans |
| Enforcement | SCP: Deny if missing |

### Tag 3: environment
| Attribute | Value |
|---|---|
| Description | Deployment environment of the resource |
| Required | Yes — SCP blocks resource creation without this tag |
| Allowed Values | production, staging, development, sandbox |
| Example | environment = production |
| Enforcement | SCP: Deny if missing |

### Tag 4: cost_centre
| Attribute | Value |
|---|---|
| Description | Financial cost centre code for chargeback |
| Required | Yes — SCP blocks resource creation without this tag |
| Allowed Values | CC-1001 (Lending), CC-2003 (Payments), CC-3050 (Platform), CC-4001 (Data) |
| Example | cost_centre = CC-1001 |
| Enforcement | SCP: Deny if missing |

### Tag 5: team
| Attribute | Value |
|---|---|
| Description | Engineering team that owns and operates the resource |
| Required | Yes — SCP blocks resource creation without this tag |
| Allowed Values | platform-infra, lending-backend, payments-team, data-engineering, frontend, security, devops |
| Example | team = lending-backend |
| Enforcement | SCP: Deny if missing |

---

## Recommended Tags (Enforced via Config Rules)

### Tag 6: service
| Attribute | Value |
|---|---|
| Description | Specific microservice or component |
| Required | Recommended |
| Example | service = loan-origination-api |
| Enforcement | Config Rule: Flag if missing |

### Tag 7: created_by
| Attribute | Value |
|---|---|
| Description | IAM user or automation role that created the resource |
| Required | Auto-applied |
| Example | created_by = terraform |
| Enforcement | Auto-tagged via CloudTrail + Lambda |

### Tag 8: ttl
| Attribute | Value |
|---|---|
| Description | Time-to-live for temporary resources |
| Required | Recommended for non-production |
| Example | ttl = 2026-12-31 |
| Enforcement | Automated cleanup Lambda for expired TTL |

### Tag 9: compliance_scope
| Attribute | Value |
|---|---|
| Description | Regulatory framework applicability |
| Required | Mandatory for data services |
| Allowed Values | pci-dss, soc2, rbi-it, gdpr, multi, none |
| Example | compliance_scope = pci-dss |
| Enforcement | Config Rule: Mandatory for RDS, S3, EC2 in payment VPC |

### Tag 10: data_classification
| Attribute | Value |
|---|---|
| Description | Sensitivity level of data processed by resource |
| Required | Mandatory for storage and database resources |
| Allowed Values | public, internal, confidential, restricted |
| Example | data_classification = restricted |
| Enforcement | Config Rule: Mandatory for S3, RDS, ElastiCache |

---

## Tag Enforcement Architecture

### Layer 1 — Preventive Controls (AWS SCPs)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyEC2WithoutMandatoryTags",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateVolume",
        "rds:CreateDBInstance",
        "s3:CreateBucket"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestedRegion": "false",
          "aws:ResourceTag/business_unit": "true",
          "aws:ResourceTag/environment": "true",
          "aws:ResourceTag/team": "true",
          "aws:ResourceTag/cost_centre": "true"
        }
      }
    }
  ]
}
```

**Scope:** Applied at AWS Organisation level — overrides all member account policies  
**Effect:** No resource can be created without all 5 mandatory tags

### Layer 2 — Detective Controls (AWS Config Rules)

| Config Rule | Evaluation | Frequency |
|---|---|---|
| REQUIRED_TAGS | All taggable resources checked against mandatory schema | Daily |
| TAG_VALUE_VALIDATION | Allowed values validated per tag key | Daily |
| COMPLIANCE_SCOPE_REQUIRED | Data services must have compliance_scope tag | Continuous |
| DATA_CLASSIFICATION_REQUIRED | Storage/DB resources must have data_classification | Continuous |

**Non-compliant resources:** Flagged in AWS Config compliance dashboard  
**Notification:** Automated alert to resource owner and FinOps team

### Layer 3 — Corrective Controls (Lambda Auto-Remediation)

```python
# Lambda function triggered by Config Rule non-compliance
def remediate_missing_tags(event, context):
    resource_id = event['detail']['resourceId']
    resource_type = event['detail']['resourceType']
    
    # Apply default tags to untagged resource
    default_tags = {
        'business_unit': 'unknown',
        'environment': 'unknown', 
        'team': 'unassigned',
        'cost_centre': 'CC-9999',
        'auto_remediated': 'true',
        'remediation_date': datetime.now().isoformat()
    }
    
    # Tag the resource
    apply_tags(resource_id, resource_type, default_tags)
    
    # Send Slack notification
    send_slack_alert(
        channel='#finops-alerts',
        message=f'Auto-remediated missing tags on {resource_id}. '
                f'Please update with correct values within 48 hours.'
    )
    
    # Create JIRA ticket for manual follow-up
    create_jira_ticket(
        summary=f'Tag remediation required: {resource_id}',
        assignee=get_resource_owner(resource_id)
    )
```

### Layer 4 — Audit Controls

| Control | Frequency | Output | Escalation |
|---|---|---|---|
| Tag compliance report | Monthly | PDF report to all team leads | Teams < 95% receive escalation notice |
| Dashboard compliance scorecard | Real-time | Engineering Manager dashboard | Visible to all managers |
| Quarterly review | Quarterly | CFO/CTO compliance summary | Persistent non-compliance → VP Engineering |
| Annual taxonomy review | Annual | Updated tag schema | Governance committee approval |

---

## Implementation Roadmap

### Phase 1 — Grace Period (Days 1–30)
- Publish tagging taxonomy to all engineering teams
- Provide self-service tagging scripts for existing resources
- Dashboard shows compliance scores (no enforcement yet)
- Target: 60% compliance by Day 30

### Phase 2 — Soft Enforcement (Days 31–60)
- Config Rules active — non-compliant resources flagged
- Lambda auto-remediation sends notifications
- Weekly compliance reports distributed to team leads
- Target: 80% compliance by Day 60

### Phase 3 — Hard Enforcement (Days 61–90)
- SCPs activated — new resources blocked without mandatory tags
- Teams below 95% compliance receive VP Engineering escalation
- Monthly chargeback reports reflect actual tag-attributed costs
- Target: 95%+ compliance by Day 90

---

## Tag Compliance Baseline & Targets

| Team | Current Compliance | 30-Day Target | 90-Day Target |
|---|---|---|---|
| data-engineering | 18% | 50% | 95% |
| lending-backend | 24% | 60% | 95% |
| platform-infra | 41% | 70% | 95% |
| payments-team | 68% | 85% | 98% |
| frontend-team | 72% | 85% | 98% |
| **Overall** | **34%** | **68%** | **95%** |

---

*Prepared by Keerthi Kavuri | FinOps Engineer | June 2026*