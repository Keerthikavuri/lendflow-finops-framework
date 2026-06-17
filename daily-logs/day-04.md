# Day 04 — Reserved Instance & Spot Strategy Analysis
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Morning Session — Reserved Instance Analysis

### Current RI Coverage Assessment

| Instance Family | Running Count | RI Covered | On-Demand | Coverage % | Industry Benchmark |
|---|---|---|---|---|---|
| m5 family | 28 | 4 | 24 | 14% | 70-80% |
| c5 family | 18 | 2 | 16 | 11% | 70-80% |
| r5 family | 12 | 1 | 11 | 8% | 70-80% |
| t3 family | 22 | 0 | 22 | 0% | 50-60% |
| **Total** | **80** | **7** | **73** | **12%** | **70-80%** |

**Critical finding: Only 12% RI coverage vs 70-80% industry benchmark**

### RI Procurement Strategy — Moderate Approach Selected

| Decision Factor | Choice | Rationale |
|---|---|---|
| Coverage Target | 75% of steady-state baseline | Balances savings vs flexibility |
| Term Length | 1-year | Lower lock-in risk for growing platform |
| Payment Structure | Partial upfront | Balanced risk/savings |
| Flexibility | Mix of convertible + standard | Allows instance family changes |
| Projected Savings | 35-45% vs on-demand | $15,000-$20,000/month |

### RI Purchase Plan

| Instance Type | Count to Reserve | Term | Payment | Monthly Savings |
|---|---|---|---|---|
| m5.large | 18 | 1-year | Partial upfront | $1,260 |
| m5.xlarge | 8 | 1-year | Partial upfront | $1,120 |
| c5.large | 10 | 1-year | Partial upfront | $610 |
| c5.xlarge | 6 | 1-year | Partial upfront | $732 |
| r5.large | 6 | 1-year | Partial upfront | $540 |
| db.r5.xlarge | 4 | 1-year | Partial upfront | $890 |
| **Total** | **52 RIs** | | | **$15,152/month** |

---

## Afternoon Session — Spot Instance Architecture

### Workload Suitability Assessment

| Workload | Spot Suitable | Reason | Interruption Strategy |
|---|---|---|---|
| CI/CD Pipelines (Jenkins) | Yes | Stateless, restartable | Checkpoint + queue |
| ML Model Training | Yes | Checkpointing supported | S3 checkpoint every 10 min |
| Batch Loan Processing | Yes | Queue-based, idempotent | SQS dead-letter queue |
| Data Analytics/ETL | Yes | Restartable jobs | Spark checkpoint |
| Document Processing | Yes | Queue-triggered | SQS visibility timeout |
| Loan Application API | No | Latency-sensitive, SLA | On-demand only |
| Payment Gateway | No | PCI DSS + availability | On-demand only |
| Credit Scoring Engine | No | RBI IT minimum replicas | On-demand only |

### Spot Architecture — CI/CD Pipeline

Spot Fleet Configuration:

Instance Types: [c5.xlarge, c5a.xlarge, m5.xlarge, m5a.xlarge]

AZ Spread: us-east-1a, us-east-1b, us-east-1c

Allocation Strategy: capacity-optimised

Base On-Demand: 2 instances (minimum pipeline capacity)

Spot Burst: up to 10 instances

Interruption Handler: drain queue → checkpoint → terminate gracefully

Estimated Savings: 65% vs on-demand

### Spot Savings Projection

| Workload | Current Monthly Cost | Spot Savings % | Monthly Savings |
|---|---|---|---|
| CI/CD Pipelines | $8,400 | 65% | $5,460 |
| ML Training | $12,000 | 70% | $8,400 |
| Batch Processing | $6,200 | 60% | $3,720 |
| Analytics/ETL | $4,800 | 65% | $3,120 |
| **Total** | **$31,400** | | **$20,700** |

*Note: Spot savings already partially captured in compute right-sizing estimates — net additional savings: ~$8,000/month*

---

## Savings Model Update — Day 4

| Category | Conservative | Expected | Optimistic |
|---|---|---|---|
| Compute Right-sizing | $16,000 | $19,000 | $22,000 |
| Database Optimisation | $3,500 | $4,800 | $6,000 |
| Storage Tier Optimisation | $4,500 | $5,500 | $6,500 |
| EBS Cleanup & Snapshots | $3,000 | $3,800 | $4,500 |
| Data Transfer Optimisation | $5,500 | $7,000 | $8,500 |
| Reserved Instances/Savings Plans | $13,000 | $16,000 | $20,000 |
| Spot Instance Strategy | $6,000 | $8,000 | $10,000 |
| **Running Total** | **$51,500** | **$64,100** | **$77,500** |

---

## Key Learnings Today
1. 12% RI coverage is extremely low — purchasing RIs for stable workloads alone saves $15,000+/month
2. Moderate RI approach chosen over aggressive 3-year to maintain flexibility for Graviton migration
3. Spot instances not suitable for PCI DSS and RBI IT constrained workloads
4. CI/CD and ML training are ideal spot candidates — high cost, fully fault-tolerant

---

