# Optimisation Recommendations — LendFlow Technologies
**Prepared by:** Keerthi Kavuri, FinOps Engineer  
**Date:** June 2026

---

## Overview

This document contains 15+ prioritised cost optimisation recommendations for LendFlow Technologies. Each recommendation includes projected savings, implementation effort, risk assessment, compliance considerations, and priority ranking based on an Impact vs Effort matrix.

**Total Projected Monthly Savings: $74,100 (expected scenario)**  
**CFO Target: $60,000/month — Exceeded by $14,100/month**

---

## Impact vs Effort Matrix

| Quadrant | Recommendations | Action |
|---|---|---|
| High Impact / Low Effort | R1, R2, R3, R4 | Do First (Week 1-2) |
| High Impact / High Effort | R5, R6, R7, R8, R9, R10 | Plan (Week 3-8) |
| Low Impact / Low Effort | R11, R12, R13 | Backlog |
| Low Impact / High Effort | R14, R15 | Deprioritise |

---

## Priority 1 — High Impact / Low Effort (Week 1-2)

### R1: Schedule Dev/Staging Auto-Shutdown
**Monthly Savings:** $10,000  
**Annual Savings:** $120,000  
**Implementation Effort:** 2 person-days  
**Risk:** Low — zero production impact  
**Compliance:** No constraints — dev/staging only  

**Description:** Configure AWS Auto Scaling scheduled actions to scale development and staging environments to zero at 7PM IST weekdays and restore at 9AM IST weekdays. Full shutdown on weekends.

**Implementation Steps:**
1. Identify all dev/staging Auto Scaling Groups
2. Create scale-down scheduled action: cron `0 13 * * 1-5` (7PM IST = 13:00 UTC)
3. Create scale-up scheduled action: cron `30 3 * * 1-5` (9AM IST = 03:30 UTC)
4. Set weekend capacity to zero
5. Notify development teams 1 week in advance

**Savings Calculation:**
- Current: 168 hours/week billed (24x7)
- After: 50 hours/week billed (9AM-7PM weekdays only)
- Reduction: 70% of dev/staging compute cost
- Monthly saving: $25,000 x 0.40 = $10,000

---

### R2: Delete Unattached EBS Volumes
**Monthly Savings:** $1,800  
**Annual Savings:** $21,600  
**Implementation Effort:** 1 person-day  
**Risk:** Low — volumes are unattached (not in use)  
**Compliance:** No constraints  

**Description:** 200+ EBS volumes remain attached to terminated instances. These volumes serve no purpose and accumulate $1,800/month in storage charges.

**Implementation Steps:**
1. Run AWS CLI query to identify all unattached volumes
2. Cross-reference with instance termination dates
3. Create snapshots of volumes > 30 days old before deletion (safety net)
4. Delete all unattached volumes
5. Create Config Rule to alert on new unattached volumes within 7 days

```bash
# Identify unattached volumes
aws ec2 describe-volumes \
  --filters Name=status,Values=available \
  --query 'Volumes[*].[VolumeId,Size,CreateTime]' \
  --output table
```

---

### R3: Clean Up Orphaned EBS Snapshots
**Monthly Savings:** $1,800  
**Annual Savings:** $21,600  
**Implementation Effort:** 1 person-day  
**Risk:** Low — snapshots from terminated instances  
**Compliance:** Retain snapshots of compliance-tagged volumes per policy  

**Description:** 847 orphaned snapshots from terminated instances accumulate $2,200/month. No snapshot lifecycle policy exists.

**Implementation Steps:**
1. Identify snapshots with no associated running instance
2. Exclude snapshots tagged compliance_scope=pci-dss or soc2
3. Delete snapshots older than 90 days from terminated instances
4. Implement Data Lifecycle Manager policy: retain last 3 snapshots per volume, delete after 90 days

---

### R4: Enable VPC Endpoints for AWS Services
**Monthly Savings:** $2,000  
**Annual Savings:** $24,000  
**Implementation Effort:** 2 person-days  
**Risk:** Low — additive change, no service disruption  
**Compliance:** Improves security posture (traffic stays on AWS network)  

**Description:** Services currently communicate with S3, SES, DynamoDB, and Lambda via internet egress. VPC Endpoints eliminate internet egress charges for AWS-internal communication.

**Endpoints to Create:**
| Service | Endpoint Type | Monthly Saving |
|---|---|---|
| S3 | Gateway (free) | $792 |
| DynamoDB | Gateway (free) | $280 |
| SES | Interface ($22/month) | $356 net |
| Lambda | Interface ($22/month) | $320 net |
| CloudWatch | Interface ($22/month) | $290 net |

---

## Priority 2 — High Impact / High Effort (Week 3-8)

### R5: Purchase Reserved Instances (52 RIs)
**Monthly Savings:** $16,000  
**Annual Savings:** $192,000  
**Implementation Effort:** 5 person-days  
**Risk:** Medium — commitment lock-in  
**Compliance:** No constraints  

**Description:** Current RI coverage is 12% vs 70-80% industry benchmark. Purchasing 52 convertible Reserved Instances (1-year partial upfront) for stable production workloads delivers $16,000/month savings.

**Purchase Plan:**
| Instance Type | Count | Term | Payment | Monthly Saving |
|---|---|---|---|---|
| m5.large | 18 | 1-year | Partial upfront | $1,260 |
| m5.xlarge | 8 | 1-year | Partial upfront | $1,120 |
| c5.large | 10 | 1-year | Partial upfront | $610 |
| c5.xlarge | 6 | 1-year | Partial upfront | $732 |
| r5.large | 6 | 1-year | Partial upfront | $540 |
| db.r5.xlarge | 4 | 1-year | Partial upfront | $890 |
| **Total** | **52** | | | **$15,152** |

**Risk Mitigation:** Convertible RIs allow exchange to different instance families if workloads migrate to Graviton or change size requirements.

---

### R6: Right-Size 40+ Over-Provisioned EC2 Instances
**Monthly Savings:** $19,000  
**Annual Savings:** $228,000  
**Implementation Effort:** 15 person-days  
**Risk:** Medium — requires performance validation  
**Compliance:** Payment gateway instances excluded (PCI DSS)  

**Description:** 40+ EC2 instances running at <20% average CPU utilisation for 30+ consecutive days. Downsizing 1-2 instance size categories delivers $19,000/month savings.

**Staged Rollout Plan:**
- Week 3: Right-size development instances (lowest risk)
- Week 4: Right-size staging instances with 1-week monitoring
- Week 5-6: Right-size production instances with 2-week monitoring per batch

**Validation Methodology:**
1. Baseline P99 latency before right-sizing
2. Right-size instance
3. Monitor CPU, memory, latency for 2 weeks
4. Roll back if P99 latency increases >10%

---

### R7: Implement S3 Lifecycle Policies
**Monthly Savings:** $5,500  
**Annual Savings:** $66,000  
**Implementation Effort:** 5 person-days  
**Risk:** Low — automated transitions, data not deleted  
**Compliance:** Audit logs and compliance buckets excluded  

**Lifecycle Policy Design:**

Standard → Infrequent Access: after 30 days

Infrequent Access → Glacier: after 90 days

Glacier → Glacier Deep Archive: after 365 days

Delete: after 2,555 days (7 years) — non-compliance data only

**Excluded Buckets:**
- lendflow-audit-logs (SOC 2 — immutable Standard for 12 months)
- lendflow-compliance (PCI DSS — 7-year Standard retention)

---

### R8: Deploy Spot Instances for CI/CD and ML Workloads
**Monthly Savings:** $8,000  
**Annual Savings:** $96,000  
**Implementation Effort:** 10 person-days  
**Risk:** Medium — spot interruption handling required  
**Compliance:** Not applicable to payment/lending APIs  

**Spot Architecture:**
- CI/CD (Jenkins): 70% spot + 30% on-demand, 4 instance types diversified
- ML Training: 80% spot + 20% on-demand, checkpointing every 10 minutes to S3
- Batch Processing: 60% spot + 40% on-demand, SQS queue-based with dead-letter queue
- Analytics ETL: 80% spot + 20% on-demand, Spark checkpoint enabled

---

### R9: Implement AZ-Aware Service Discovery
**Monthly Savings:** $4,000  
**Annual Savings:** $48,000  
**Implementation Effort:** 8 person-days  
**Risk:** Medium — requires service mesh changes  
**Compliance:** No constraints  

**Description:** loan-origination-api and credit-scoring-engine communicate across AZs, costing $3,680/month in cross-AZ transfer. AZ-aware routing via AWS Cloud Map reduces this to near-zero.

---

### R10: Implement Auto-Scaling for 6 Services
**Monthly Savings:** $6,000  
**Annual Savings:** $72,000  
**Implementation Effort:** 10 person-days  
**Risk:** Medium — scaling policy tuning required  
**Compliance:** Min instance counts enforced for RBI IT and PCI DSS services  

**Services:** Loan Application API, Credit Scoring Engine, Document Processing, Payment Gateway, Reporting/Analytics, Notification Service.

---

## Priority 3 — Low Impact / Low Effort (Backlog)

### R11: Right-Size RDS Instances
**Monthly Savings:** $4,800 | **Effort:** 5 days | **Risk:** Medium

Downsize rds-loans-prod from db.r5.2xlarge to db.r5.xlarge ($445/month saving). Migrate rds-analytics to Aurora Serverless v2 ($890/month saving). Right-size 2 staging RDS instances ($400/month saving).

---

### R12: Deploy CloudFront CDN for Static Assets
**Monthly Savings:** $1,200 | **Effort:** 3 days | **Risk:** Low

Static assets (loan documents, UI assets) served directly from S3 origin. CloudFront caching reduces origin fetches by 85%, eliminating $1,200/month in egress charges.

---

### R13: Optimise CloudWatch Log Retention
**Monthly Savings:** $800 | **Effort:** 2 days | **Risk:** Low

Application logs retained indefinitely. Setting 30-day retention for debug logs and 90-day for application logs reduces CloudWatch storage costs by $800/month. Compliance logs retain 12-month policy.

---

## Priority 4 — Deprioritise

### R14: Consolidate NAT Gateways in Dev Environments
**Monthly Savings:** $400 | **Effort:** 3 days | **Risk:** Low

4 NAT Gateways in dev environment — consolidate to 1. Low savings relative to effort.

---

### R15: Migrate to Graviton Processors
**Monthly Savings:** $8,000 (future) | **Effort:** 30+ days | **Risk:** High

Graviton3 instances offer 20% better price-performance. High effort — requires application compatibility testing. Recommended as 6-month roadmap item after immediate optimisations complete.

---

## 90-Day Implementation Roadmap

| Week | Recommendations | Expected Cumulative Savings |
|---|---|---|
| Week 1 | R2, R3, R4 (EBS cleanup, snapshots, VPC Endpoints) | $5,600/month |
| Week 2 | R1 (Dev/staging scheduled shutdown) | $15,600/month |
| Week 3-4 | R6 partial (Dev + staging right-sizing) | $28,000/month |
| Week 5-6 | R5 (RI purchase), R6 complete (prod right-sizing) | $55,000/month |
| Week 7-8 | R7 (S3 lifecycle), R10 (auto-scaling) | $66,500/month |
| Week 9-10 | R8 (spot instances) | $72,500/month |
| Week 11-12 | R9 (AZ-aware routing), R11, R12, R13 | $74,100/month |

---

*Prepared by Keerthi Kavuri | FinOps Engineer | June 2026*