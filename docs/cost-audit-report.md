# Cloud Cost Audit Report — LendFlow Technologies
**Prepared by:** Sai Keerthi Kavuri, FinOps Engineer  
**Date:** June 2026  
**Classification:** Internal — Confidential

---

## Executive Summary

LendFlow Technologies' AWS monthly bill has escalated from **$50,000 to $180,000** over 12 months while revenue only doubled from $500,000 to $1,000,000/month. This audit identifies **$74,100/month** in addressable waste across eight categories, exceeding the CFO's mandate of $60,000/month reduction. All recommendations have been validated against PCI DSS v4.0, SOC 2 Type II, RBI IT Framework, and GDPR compliance obligations.

**Bottom Line:** LendFlow is wasting approximately **41% of its cloud spend** on over-provisioned compute, idle environments, missing reserved capacity, unoptimised storage, and unnecessary data transfer.

---

## Methodology

### Data Sources Analysed
| Dataset | Records | Analysis Period |
|---|---|---|
| monthly_cost_summary.csv | 72 rows (6 months x 12 categories) | Jan–Jun 2026 |
| daily_cost_detail.csv | ~10,800 rows | Jan–Jun 2026 |
| instance_utilisation.csv | ~2,400 rows | Jan–Jun 2026 |
| storage_inventory.csv | ~500 rows | Jan–Jun 2026 |
| data_transfer_log.csv | ~3,600 rows | Jan–Jun 2026 |
| reserved_instance_coverage.csv | ~200 rows | Jan–Jun 2026 |
| tag_compliance_report.csv | ~1,500 rows | Jan–Jun 2026 |
| cost_anomaly_events.csv | ~80 rows | Jan–Jun 2026 |

### Analytical Techniques Applied
- Pivot table analysis by service, environment, team, and time period
- Pareto analysis: identified top 20% of resources driving 80% of waste
- Utilisation distribution analysis: CPU/memory histograms across all instances
- Trend analysis: month-over-month growth rates by category
- Correlation analysis: traffic volumes vs scaling events vs cost spikes
- Scenario modelling: conservative/expected/optimistic savings projections

---

## Current State Assessment

### Monthly Cost Breakdown (Month 6 — $180,000 total)

| Service Category | Monthly Cost | % of Bill | MoM Growth | Budget |
|---|---|---|---|---|
| Compute (EC2/EKS) | $92,000 | 51% | +6.5% | $60,000 |
| Database (RDS/ElastiCache) | $38,000 | 21% | +5.8% | $25,000 |
| Data Transfer | $19,000 | 11% | +8.2% | $8,000 |
| Storage (S3/EBS) | $18,000 | 10% | +3.1% | $12,000 |
| Networking (ELB/NAT) | $8,000 | 4% | +4.0% | $5,000 |
| Monitoring (CloudWatch) | $3,000 | 2% | +2.5% | $2,000 |
| Security (WAF/Shield/KMS) | $2,000 | 1% | +1.0% | $2,000 |
| **Total** | **$180,000** | **100%** | **+6.5%** | **$114,000** |

### 6-Month Cost Trend

| Month | Total Spend | MoM Growth | Budget | Variance |
|---|---|---|---|---|
| Month 1 | $125,000 | Baseline | $100,000 | +25% |
| Month 2 | $138,000 | +10.4% | $100,000 | +38% |
| Month 3 | $149,000 | +8.0% | $100,000 | +49% |
| Month 4 | $158,000 | +6.0% | $100,000 | +58% |
| Month 5 | $169,000 | +7.0% | $100,000 | +69% |
| Month 6 | $180,000 | +6.5% | $100,000 | +80% |

### Key Financial Metrics
- **Cloud cost as % of revenue:** 18% (industry benchmark: 8–10%)
- **Gross margin erosion:** 75% → 55% (infrastructure costs primary driver)
- **Cost per loan application:** $0.00036 (target: $0.00022)
- **Tag compliance:** 34% (industry benchmark: 95%+)
- **Reserved Instance coverage:** 12% (industry benchmark: 70–80%)

---

## Waste Identification by Category

### Category 1: Over-Provisioned Compute
**Monthly Waste: ~$22,000**

| Finding | Detail | Monthly Cost | Savings Potential |
|---|---|---|---|
| 40+ EC2 instances at <20% CPU for 30+ days | m5.xlarge, c5.xlarge, r5.xlarge | $18,500 | $14,000–$18,000 |
| Development instances provisioned for peak load | Running at 9% avg CPU | $8,200 | $6,000 |
| Staging instances never right-sized | Running at 14% avg CPU | $6,800 | $5,000 |

**Top 5 Right-Sizing Candidates:**
| Instance | Current Type | Avg CPU | Monthly Cost | Target Type | Savings |
|---|---|---|---|---|---|
| i-009i | m5.4xlarge | 6% | $560 | m5.large | $420 |
| i-010j | c5.4xlarge | 10% | $488 | c5.large | $366 |
| i-007g | c5.2xlarge | 14% | $244 | c5.large | $183 |
| i-006f | m5.2xlarge | 7% | $280 | m5.large | $175 |
| i-002b | m5.2xlarge | 8% | $280 | m5.large | $175 |

**Compliance Note:** Payment gateway instances excluded from right-sizing (PCI DSS). Credit scoring engine minimum 3 replicas enforced (RBI IT Framework).

---

### Category 2: Idle Development & Staging Environments
**Monthly Waste: ~$15,000**

| Environment Type | Instance Count | Monthly Cost | Usage Pattern | Waste |
|---|---|---|---|---|
| Development instances | 22 | $25,000 | 9AM–7PM weekdays only | $16,250 |
| Staging instances | 18 | $22,000 | 9AM–7PM weekdays only | $14,300 |
| Idle load balancers (dev) | 6 | $1,200 | Zero registered targets | $1,200 |

**Solution:** Scheduled auto-scaling — scale to zero at 7PM IST, restore at 9AM IST weekdays. Weekends: zero capacity.
- Hours saved: 128 hours/week (off-hours + weekends)
- Hours billed currently: 168 hours/week (24x7)
- **Savings: $10,000/month**

---

### Category 3: Missing Reserved Instance Coverage
**Monthly Waste: ~$18,000**

| Instance Family | On-Demand Count | RI Covered | Coverage % | Premium Paid |
|---|---|---|---|---|
| m5 family | 24 | 4 | 14% | $8,400/month |
| c5 family | 16 | 2 | 11% | $5,600/month |
| r5 family | 11 | 1 | 8% | $3,300/month |
| t3 family | 22 | 0 | 0% | $2,200/month |

**Recommendation:** Purchase 52 Reserved Instances (1-year partial upfront, convertible) covering 75% of steady-state baseline.
- **Savings: $15,000–$20,000/month**

---

### Category 4: Unoptimised Storage
**Monthly Waste: ~$8,000**

| Finding | Volume | Monthly Cost | Action | Savings |
|---|---|---|---|---|
| S3 data not accessed 90+ days on Standard tier | 35TB | $805 | Transition to IA/Glacier | $600 |
| 200+ unattached EBS volumes | 186 volumes | $1,800 | Delete immediately | $1,800 |
| 847 orphaned EBS snapshots | Various | $2,200 | Lifecycle policy cleanup | $1,800 |
| Oversized EBS volumes (<25% utilised) | 42 volumes | $1,800 | Rightsize to actual usage | $1,200 |

**Compliance Note:** lendflow-audit-logs bucket excluded from lifecycle policies (SOC 2 — 12-month immutable retention). lendflow-compliance bucket excluded (PCI DSS — 7-year retention).

---

### Category 5: Excessive Cross-AZ Data Transfer
**Monthly Waste: ~$9,000**

| Transfer Path | GB/Month | Monthly Cost | Root Cause | Fix |
|---|---|---|---|---|
| loan-origination ↔ credit-scoring (cross-AZ) | 18,400 | $3,680 | Services in different AZs | AZ-aware routing |
| payment-gateway ↔ fraud-detection (cross-AZ) | 12,200 | $2,440 | No service co-location | Co-locate services |
| data-pipeline → S3 (internet egress) | 8,800 | $792 | No VPC Endpoint | VPC Gateway Endpoint |
| reporting ↔ analytics-db (cross-AZ) | 7,600 | $1,520 | Read replica in wrong AZ | Same-AZ replica |

**Addressable savings: $6,000–$8,000/month**

---

### Category 6: Missing Reserved Coverage — Database
**Monthly Waste: ~$4,000**

| DB Instance | Type | Avg CPU | Monthly Cost | Action | Savings |
|---|---|---|---|---|---|
| rds-loans-prod | db.r5.2xlarge | 12% | $890 | Rightsize + RI | $445 |
| rds-analytics | db.r5.4xlarge | 8% | $1,780 | Aurora Serverless | $890 |
| rds-staging-01 | db.r5.xlarge | 6% | $445 | Rightsize | $200 |
| rds-staging-02 | db.r5.xlarge | 7% | $445 | Rightsize | $200 |

---

### Category 7: Orphaned & Idle Resources
**Monthly Waste: ~$3,000**

| Resource Type | Count | Monthly Cost | Action |
|---|---|---|---|
| Unattached Elastic IPs | 12 | $43 | Release immediately |
| Idle NAT Gateways (dev) | 4 | $560 | Consolidate to 1 |
| Empty load balancers | 6 | $1,200 | Delete |
| Unused Lambda functions | 28 | $180 | Archive/delete |
| Abandoned CloudWatch dashboards | 14 | $42 | Delete |

---

### Category 8: Tag Compliance & Dark Spend
**Monthly Impact: ~$48,000 unattributable**

| Team | Resources | Compliance % | Dark Spend |
|---|---|---|---|
| data-engineering | 42 | 18% | $8,400 |
| lending-backend | 38 | 24% | $6,800 |
| platform-infra | 56 | 41% | $12,300 |
| payments-team | 28 | 68% | $4,200 |
| **Total unattributable** | **294/408** | **34%** | **~$48,000** |

---

## Total Addressable Savings Summary

| Category | Conservative | Expected | Optimistic |
|---|---|---|---|
| Over-provisioned Compute | $16,000 | $19,000 | $22,000 |
| Idle Dev/Staging Environments | $8,000 | $10,000 | $12,000 |
| Missing Reserved Instances | $13,000 | $16,000 | $20,000 |
| Unoptimised Storage | $4,500 | $5,500 | $6,500 |
| EBS & Snapshot Cleanup | $3,000 | $3,800 | $4,500 |
| Data Transfer Optimisation | $5,500 | $7,000 | $8,500 |
| Database Optimisation | $3,500 | $4,800 | $6,000 |
| Spot Instance Strategy | $6,000 | $8,000 | $10,000 |
| **Total Monthly Savings** | **$59,500** | **$74,100** | **$89,500** |
| **Total Annual Savings** | **$714,000** | **$889,200** | **$1,074,000** |

**CFO Target: $60,000/month — Expected scenario delivers $74,100/month (24% above target)**

---

## Compliance Constraint Summary

| Recommendation | PCI DSS | SOC 2 | RBI IT | GDPR | Decision |
|---|---|---|---|---|---|
| EC2 right-sizing (non-payment) | ✅ | ✅ | ✅ | ✅ | Proceed |
| Payment gateway right-sizing | ❌ | ✅ | ✅ | ✅ | Skip |
| S3 lifecycle (audit logs) | ✅ | ❌ | ✅ | ✅ | Exclude audit logs |
| Dev environment shutdown | ✅ | ✅ | ✅ | ✅ | Proceed |
| Cross-region consolidation (EU) | ✅ | ✅ | ✅ | ❌ | Skip EU data |
| Reserved instances | ✅ | ✅ | ✅ | ✅ | Proceed |
| Spot for CI/CD + ML | ✅ | ✅ | ✅ | ✅ | Proceed |

---

