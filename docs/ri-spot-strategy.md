# Reserved Instance & Spot Strategy — LendFlow Technologies
**Prepared by:** Keerthi Kavuri, FinOps Engineer  
**Date:** June 2026

---

## Overview

This document defines the Reserved Instance (RI) and Spot Instance procurement strategy for LendFlow Technologies. Current RI coverage is 12% vs 70–80% industry benchmark, representing $18,000/month in avoidable on-demand premium. This strategy delivers $24,000/month combined savings through disciplined commitment purchasing and spot architecture.

---

## Part 1: Reserved Instance Strategy

### Current State Assessment

| Instance Family | Running | RI Covered | Coverage % | Monthly Premium |
|---|---|---|---|---|
| m5 family | 24 | 4 | 14% | $8,400 |
| c5 family | 16 | 2 | 11% | $5,600 |
| r5 family | 11 | 1 | 8% | $3,300 |
| t3 family | 22 | 0 | 0% | $2,200 |
| **Total** | **73** | **7** | **12%** | **$19,500** |

### Commitment Decision Framework

**Selected Approach: Moderate (1-year partial upfront, convertible)**

| Factor | Conservative | **Selected: Moderate** | Aggressive |
|---|---|---|---|
| Coverage Target | 60–70% | **75%** | 80–90% |
| Term | 1-year no-upfront | **1-year partial upfront** | 3-year all-upfront |
| Flexibility | Convertible only | **Mix convertible + standard** | Standard only |
| Savings vs On-demand | 20–30% | **30–45%** | 45–72% |
| Risk | Low | **Medium** | High |

**Rationale for Moderate Approach:**
- LendFlow is growing rapidly — 3-year lock-in risks over-commitment
- Convertible RIs allow exchange if migrating to Graviton processors
- 1-year term balances savings vs flexibility for Series B growth phase

### RI Purchase Plan

| Instance Type | Count | Term | Payment | On-Demand/mo | RI/mo | Monthly Saving |
|---|---|---|---|---|---|---|
| m5.large | 18 | 1-year | Partial upfront | $3,024 | $1,764 | $1,260 |
| m5.xlarge | 8 | 1-year | Partial upfront | $2,688 | $1,568 | $1,120 |
| c5.large | 10 | 1-year | Partial upfront | $1,220 | $610 | $610 |
| c5.xlarge | 6 | 1-year | Partial upfront | $1,464 | $732 | $732 |
| r5.large | 6 | 1-year | Partial upfront | $1,140 | $600 | $540 |
| db.r5.xlarge | 4 | 1-year | Partial upfront | $1,780 | $890 | $890 |
| **Total** | **52** | | | **$11,316** | **$6,164** | **$5,152** |

**Total Monthly Savings: $15,152/month**  
**Total Annual Savings: $181,824**  
**Upfront Payment Required: ~$180,000 (partial upfront)**  
**Payback Period: 11.9 months**

### Risk Assessment

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Workload migrates to Graviton | Medium | Medium | Use convertible RIs — exchangeable |
| LendFlow scales down post-Series B delay | Low | High | 1-year term limits exposure vs 3-year |
| Instance family becomes obsolete | Low | Low | Convertible RIs cover family changes |
| Over-commitment on specific AZ | Medium | Low | Regional RIs — not AZ-specific |

### Sensitivity Analysis

| RI Utilisation Rate | Monthly Saving | Annual Saving |
|---|---|---|
| 100% utilisation | $15,152 | $181,824 |
| 90% utilisation | $13,637 | $163,644 |
| 80% utilisation | $12,122 | $145,464 |
| 70% utilisation | $10,606 | $127,272 |

**Break-even utilisation: 68%** — still profitable if 1/3 of reserved capacity is unused.

---

## Part 2: Spot Instance Strategy

### Workload Suitability Matrix

| Workload | Spot Suitable | Interruption Tolerance | Strategy |
|---|---|---|---|
| CI/CD Pipelines (Jenkins) | ✅ Yes | High — restartable | Diversified fleet + queue |
| ML Model Training | ✅ Yes | High — checkpointing | S3 checkpoint every 10 min |
| Batch Loan Processing | ✅ Yes | High — idempotent | SQS dead-letter queue |
| Data Analytics/ETL | ✅ Yes | High — Spark checkpoint | Spark checkpoint to S3 |
| Document Processing | ✅ Yes | High — queue-based | SQS visibility timeout |
| Loan Application API | ❌ No | Zero — SLA critical | On-demand only |
| Payment Gateway | ❌ No | Zero — PCI DSS | On-demand only |
| Credit Scoring Engine | ❌ No | Zero — RBI IT | On-demand only |

### Spot Architecture — CI/CD Pipeline (Jenkins)

Spot Fleet Configuration:

Instance Types:

- c5.xlarge    (primary)

- c5a.xlarge   (fallback 1)

- m5.xlarge    (fallback 2)

- m5a.xlarge   (fallback 3)
AZ Distribution:

- us-east-1a: 40%

- us-east-1b: 35%

- us-east-1c: 25%
Allocation Strategy: capacity-optimized

Base On-Demand Capacity: 2 instances

Spot Burst: up to 10 instances

Interruption Handling:

1. Spot interruption notice received (2 min warning)

2. Jenkins drains current build job to queue

3. Build state checkpointed to S3

4. Instance terminates gracefully

5. New spot instance picks up from S3 checkpoint

6. Build resumes from last checkpoint
Estimated Savings: 65% vs on-demand = $5,460/month

### Spot Architecture — ML Model Training

Spot Fleet Configuration:

Instance Types:

- c5.2xlarge   (primary)

- c5a.2xlarge  (fallback 1)

- m5.2xlarge   (fallback 2)

- m5a.2xlarge  (fallback 3)
Checkpointing Strategy:

- Checkpoint frequency: every 10 minutes to S3

- Checkpoint location: s3://lendflow-ml-checkpoints/{job_id}/

- On interruption: save final checkpoint, terminate

- On restart: load latest checkpoint, resume training
Estimated Savings: 70% vs on-demand = $8,400/month

### Spot Architecture — Batch Loan Processing

Architecture:

Producer: Loan application events → SQS queue

Consumer: Spot instances pulling from SQS
SQS Configuration:

- Visibility timeout: 300 seconds

- Dead-letter queue: after 3 failed attempts

- Message retention: 14 days
On Spot Interruption:

1. Message visibility timeout expires

2. Message returns to queue automatically

3. New spot instance picks up message

4. Processing resumes (idempotent design)
Estimated Savings: 60% vs on-demand = $3,720/month

### Spot Savings Summary

| Workload | Current Monthly Cost | Spot % | Monthly Saving |
|---|---|---|---|
| CI/CD Pipelines | $8,400 | 65% | $5,460 |
| ML Model Training | $12,000 | 70% | $8,400 |
| Batch Loan Processing | $6,200 | 60% | $3,720 |
| Analytics/ETL | $4,800 | 65% | $3,120 |
| **Total Gross Saving** | **$31,400** | | **$20,700** |
| Less: already in compute right-sizing | | | -$12,700 |
| **Net Additional Saving** | | | **$8,000/month** |

### Spot Interruption Rate Sensitivity

| Interruption Rate | Effective Saving | Annual Impact |
|---|---|---|
| 5% interruption | $7,600/month | $91,200 |
| 10% interruption | $7,200/month | $86,400 |
| 20% interruption | $6,400/month | $76,800 |
| 30% interruption | $5,600/month | $67,200 |

**All scenarios remain highly profitable even at 30% interruption rate.**

---

## Combined RI + Spot Savings

| Strategy | Monthly Saving | Annual Saving |
|---|---|---|
| Reserved Instances (52 RIs) | $15,152 | $181,824 |
| Spot Instances (4 workloads) | $8,000 | $96,000 |
| **Total Combined** | **$23,152** | **$277,824** |

---

## Governance & Review

### RI Portfolio Management
- **Monthly:** Review RI utilisation rates — flag any RI below 80% utilisation
- **Quarterly:** Assess upcoming RI expirations (60-day advance notice)
- **Quarterly:** Evaluate convertible RI exchange opportunities (Graviton, new families)
- **Annually:** RI renewal decision with updated workload forecast

### Spot Performance Monitoring
- **Daily:** Spot interruption rate by workload type
- **Weekly:** Spot vs on-demand cost comparison
- **Monthly:** Spot architecture effectiveness review

---

*Prepared by Keerthi Kavuri | FinOps Engineer | June 2026*