# Day 05 — Tag Compliance Analysis & Taxonomy Design
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Morning Session — Tag Compliance Analysis

### Overall Tag Compliance Summary

| Resource Type | Total Resources | Compliant | Non-Compliant | Compliance % |
|---|---|---|---|---|
| EC2 Instances | 80 | 31 | 49 | 39% |
| RDS Instances | 24 | 10 | 14 | 42% |
| S3 Buckets | 28 | 8 | 20 | 29% |
| EBS Volumes | 186 | 42 | 144 | 23% |
| Load Balancers | 18 | 6 | 12 | 33% |
| Lambda Functions | 64 | 14 | 50 | 22% |
| ElastiCache | 8 | 3 | 5 | 38% |
| **Total** | **408** | **114** | **294** | **34%** |

**Overall compliance: 34% vs industry benchmark of 95%+**

### Most Commonly Missing Tags

| Tag Key | Missing Count | % Resources Missing |
|---|---|---|
| cost_centre | 287 | 70% |
| business_unit | 241 | 59% |
| environment | 198 | 49% |
| team | 312 | 76% |
| product | 298 | 73% |

### Dark Spend Analysis
- Untagged resources: 294 out of 408 (72%)
- Estimated dark spend: ~$48,000/month unattributable
- Cannot be allocated to any business unit or cost centre
- Makes chargeback/showback impossible for 72% of infrastructure

### Worst Compliance by Team

| Team | Resources | Compliance % |
|---|---|---|
| data-engineering | 42 | 18% |
| lending-backend | 38 | 24% |
| platform-infra | 56 | 41% |
| payments-team | 28 | 68% |
| frontend-team | 22 | 72% |

---

## Afternoon Session — Tagging Taxonomy Design

### Mandatory Tag Schema

| Tag Key | Description | Example Values | Enforcement |
|---|---|---|---|
| business_unit | Top-level division | lending, payments, platform | SCP: Deny without tag |
| product | Product/service line | personal_loans, credit_line | SCP: Deny without tag |
| environment | Deployment environment | production, staging, development | SCP: Deny without tag |
| cost_centre | Financial cost centre | CC-1001, CC-2003, CC-3050 | SCP: Deny without tag |
| team | Owning engineering team | platform-infra, lending-backend | SCP: Deny without tag |
| service | Specific microservice | loan-origination-api | Tag policy: recommended |
| created_by | IAM user/automation | terraform, jenkins | Auto-tagged via CloudTrail |
| ttl | Time-to-live | 2026-12-31, permanent | Automated cleanup |
| compliance_scope | Regulatory framework | pci-dss, soc2, rbi-it, gdpr | Mandatory for data services |
| data_classification | Sensitivity level | public, confidential, restricted | Mandatory for storage/DB |

### Tag Enforcement Architecture

**Layer 1 — Preventive Controls (SCPs)**
- Deny EC2, RDS, S3, EBS creation without all 5 mandatory tags
- Applied at AWS Organisation level — cannot be overridden by member accounts

**Layer 2 — Detective Controls (Config Rules)**
- AWS Config Rule: REQUIRED_TAGS evaluates all taggable resources
- Non-compliant resources flagged in compliance dashboard
- Daily evaluation schedule

**Layer 3 — Corrective Controls (Lambda)**
- Lambda function triggered by Config Rule violations
- Auto-applies default tags: environment=unknown, team=unassigned
- Sends Slack notification to #finops-alerts channel
- Creates JIRA ticket for manual remediation

**Layer 4 — Audit Controls**
- Monthly tag compliance report generated automatically
- Teams below 95% compliance receive escalation notice
- Persistent non-compliance reported to VP Engineering

---

## Key Learnings Today
1. 34% tag compliance means 66% of spend is invisible — governance cannot work without visibility
2. data-engineering team has worst compliance at 18% — needs immediate intervention
3. Dark spend of $48,000/month means FinOps decisions are based on incomplete data
4. SCP-based enforcement is the only reliable preventive control — manual policies fail

---

## Tomorrow's Plan
- Analyse cost_anomaly_events.csv
- Design multi-layered anomaly detection framework
- Create anomaly investigation runbook template