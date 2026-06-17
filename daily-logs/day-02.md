# Day 02 — Deep-Dive Cost Analysis: Compute & Database
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Morning Session — Instance Utilisation Analysis

### Over-Provisioned EC2 Instances Identified

| Instance ID | Type | Avg CPU | Avg Mem | Hours/Day | Monthly Cost | Recommended | Savings |
|---|---|---|---|---|---|---|---|
| i-001a | m5.xlarge | 12% | 18% | 24 | $140 | m5.large | $70 |
| i-002b | m5.2xlarge | 8% | 14% | 24 | $280 | m5.large | $175 |
| i-003c | c5.xlarge | 15% | 22% | 24 | $122 | c5.large | $61 |
| i-004d | m5.xlarge | 9% | 16% | 24 | $140 | m5.large | $70 |
| i-005e | r5.xlarge | 11% | 28% | 24 | $181 | r5.large | $90 |
| i-006f | m5.2xlarge | 7% | 12% | 24 | $280 | m5.large | $175 |
| i-007g | c5.2xlarge | 14% | 19% | 24 | $244 | c5.large | $183 |
| i-008h | m5.xlarge | 18% | 25% | 24 | $140 | m5.large | $70 |
| i-009i | m5.4xlarge | 6% | 11% | 24 | $560 | m5.large | $420 |
| i-010j | c5.4xlarge | 10% | 17% | 24 | $488 | c5.large | $366 |

**Total compute right-sizing opportunity: ~$18,000–$22,000/month across 40+ instances**

### Instance Categorisation by Environment

| Environment | Instance Count | Monthly Cost | Avg CPU | Right-sizing Potential |
|---|---|---|---|---|
| Production | 28 | $45,000 | 38% | $8,000 (compliance-constrained) |
| Staging | 18 | $22,000 | 14% | $9,000 |
| Development | 22 | $25,000 | 9% | $12,000 |

### Compliance Flags
- **Payment gateway instances (prod):** Excluded from right-sizing — PCI DSS isolation requirement
- **Credit scoring engine:** Minimum 3 replicas required — RBI IT Framework
- **Audit logging instances:** Cannot reduce below 2 AZ — SOC 2 requirement

---

## Afternoon Session — Database Analysis

### Oversized RDS Instances

| DB Instance | Type | Avg CPU | Avg Connections | Monthly Cost | Recommendation | Savings |
|---|---|---|---|---|---|---|
| rds-loans-prod | db.r5.2xlarge | 12% | 45/500 | $890 | db.r5.xlarge | $445 |
| rds-credit-prod | db.r5.xlarge | 15% | 38/200 | $445 | db.r5.large | $200 |
| rds-payments-prod | db.r5.2xlarge | 18% | 82/500 | $890 | Keep (PCI DSS) | $0 |
| rds-analytics | db.r5.4xlarge | 8% | 12/1000 | $1,780 | Aurora Serverless | $890 |
| rds-staging-01 | db.r5.xlarge | 6% | 8/200 | $445 | db.r5.large | $200 |
| rds-staging-02 | db.r5.xlarge | 7% | 5/200 | $445 | db.r5.large | $200 |
| elasticache-01 | cache.r5.xlarge | 22% | Hit rate: 61% | $220 | cache.r5.large | $110 |

**Total database optimisation opportunity: ~$4,000–$6,000/month**

### Key Database Findings
- Analytics RDS running 24/7 for batch jobs that run only 4 hours/day → Aurora Serverless v2 migration saves ~$890/month
- Read replica on rds-loans-prod underutilised — consolidation saves $200/month
- ElastiCache hit rate at 61% (benchmark: 85%+) — cache warming strategy needed

---

## Savings Model — Day 2 Progress

| Category | Conservative | Expected | Optimistic |
|---|---|---|---|
| Compute Right-sizing | $16,000 | $19,000 | $22,000 |
| Database Optimisation | $3,500 | $4,800 | $6,000 |
| **Day 2 Total** | **$19,500** | **$23,800** | **$28,000** |

---

## Key Learnings Today
1. Development environments are massively over-provisioned — averaging only 9% CPU
2. Analytics database running 24/7 for 4-hour workloads is a clear Aurora Serverless candidate
3. Payment gateway instances cannot be touched — PCI DSS creates a hard constraint
4. ElastiCache hit rate at 61% suggests application-level caching inefficiency, not just infra issue

---

## Tomorrow's Plan
- Analyse storage_inventory.csv — identify S3 lifecycle and EBS optimisation opportunities
- Analyse data_transfer_log.csv — identify top 10 costliest transfer paths
- Add Storage and Data Transfer tabs to savings model