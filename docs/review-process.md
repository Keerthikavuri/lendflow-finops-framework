# FinOps Review Process & Reporting — LendFlow Technologies
**Prepared by:** Keerthi Kavuri, FinOps Engineer  
**Date:** June 2026

---

## Overview

This document defines the FinOps review process, reporting templates, and maturity assessment framework for LendFlow Technologies. A structured review cadence ensures optimisation gains are sustained and governance decisions are made with accurate, timely data.

---

## Monthly FinOps Report Template

### Section 1: Executive Summary

Month [X] cloud spend totalled $[actual] against a budget of $[budget],

representing a [+/-Z%] variance. The largest contributor to variance was

[service/team] at $[X] over budget due to [reason]. Key optimisation

achievements this month include [savings realised: $X]. Three items require

immediate attention: [item 1], [item 2], [item 3].

### Section 2: Budget vs Actual

| Category | Budget | Actual | Variance $ | Variance % | Status |
|---|---|---|---|---|---|
| Compute (EC2/EKS) | $X | $X | $X | X% | 🔴/🟡/🟢 |
| Database (RDS/ElastiCache) | $X | $X | $X | X% | 🔴/🟡/🟢 |
| Storage (S3/EBS) | $X | $X | $X | X% | 🔴/🟡/🟢 |
| Data Transfer | $X | $X | $X | X% | 🔴/🟡/🟢 |
| Networking (ELB/NAT) | $X | $X | $X | X% | 🔴/🟡/🟢 |
| Monitoring (CloudWatch) | $X | $X | $X | X% | 🔴/🟡/🟢 |
| **Total** | **$X** | **$X** | **$X** | **X%** | |

**Status Key:** 🟢 Within 10% | 🟡 10–20% over | 🔴 >20% over

*Explanation required for any category exceeding 10% variance.*

### Section 3: Top Cost Drivers

**Top 5 by Absolute Spend:**
1. [Service]: $[X]/month — [trend vs last month]
2. [Service]: $[X]/month
3. [Service]: $[X]/month
4. [Service]: $[X]/month
5. [Service]: $[X]/month

**Top 5 by Month-over-Month Growth Rate:**
1. [Service]: +[X]% — [root cause if anomalous]
2. [Service]: +[X]%
3. [Service]: +[X]%
4. [Service]: +[X]%
5. [Service]: +[X]%

### Section 4: Optimisation Achievements
| Optimisation | Savings Realised | Cumulative YTD |
|---|---|---|
| Dev/staging scheduled shutdown | $10,000 | $10,000 |
| EBS volume cleanup | $1,800 | $11,800 |
| Snapshot lifecycle policies | $1,800 | $13,600 |
| [Next month optimisation] | $X | $X |

**Total savings realised this month: $[X]**  
**Cumulative savings YTD: $[X]**  
**Remaining to target: $[X]**

### Section 5: Upcoming Actions (Next 30 Days)
| Action | Owner | Due Date | Expected Saving |
|---|---|---|---|
| EC2 right-sizing (dev environment) | DevOps team | [date] | $6,000/month |
| Reserved Instance purchase | FinOps Lead | [date] | $16,000/month |
| S3 lifecycle policies | DevOps team | [date] | $5,500/month |

### Section 6: Risk Items
| Risk | Probability | Financial Impact | Mitigation |
|---|---|---|---|
| RI expiring next month | High | $2,400/month premium | Renew by [date] |
| Data Engineering tag compliance 18% | High | $8,400 dark spend | Escalation to VP Eng |
| Compliance audit scheduled | Medium | Potential findings | Pre-audit review |

---

## Quarterly Strategic Review Package

### Component 1: 12-Month Cost Trend with Milestones
- Line chart: Monthly spend with annotations for key events
- Milestones: RI purchase, right-sizing completion, SCP activation
- Forecast: Next 3 months based on current trajectory

### Component 2: Unit Economics Evolution
| Quarter | Cost/Loan Application | Cost/Customer | Cost/API Call |
|---|---|---|---|
| Q1 2026 | $0.00042 | $1.82 | $0.000008 |
| Q2 2026 | $0.00036 | $1.56 | $0.000007 |
| Q3 2026 Target | $0.00022 | $0.95 | $0.000004 |

### Component 3: RI/SP Portfolio Performance
| RI Pool | Count | Utilisation | Savings Realised | vs Projected |
|---|---|---|---|---|
| m5 family | 18 | 94% | $1,260 | +2% |
| c5 family | 16 | 88% | $610 | -5% |
| r5 family | 6 | 96% | $540 | +1% |
| **Total** | **40** | **92%** | **$2,410** | **-1%** |

**Expiring next quarter:** [list RIs expiring in next 90 days with renewal recommendation]

### Component 4: Architecture Investment Cases
Template for each investment case:

Investment: [e.g., Graviton3 migration for lending-backend]

Current Cost: $[X]/month

Projected Cost After: $[Y]/month

Monthly Saving: $[Z]/month

Implementation Cost: $[W] (one-time)

Payback Period: [X] months

Risk: Low/Medium/High

Recommendation: Approve/Defer/Reject

---

## FinOps Maturity Assessment Framework

### Assessment Dimensions & Criteria

**Dimension 1: Visibility**

| Level | Criteria |
|---|---|
| Crawl | Some cost data available, <50% tag compliance, no real-time dashboards |
| Walk | >80% tag compliance, real-time dashboards, team-level cost allocation |
| Run | >95% tag compliance, unit economics tracked, anomaly detection <4 hours |

**Dimension 2: Optimisation**

| Level | Criteria |
|---|---|
| Crawl | Manual right-sizing occasionally, <20% RI coverage, no spot usage |
| Walk | Systematic right-sizing quarterly, 50%+ RI coverage, spot for some workloads |
| Run | Continuous right-sizing, 75%+ RI coverage, 40%+ spot for eligible workloads |

**Dimension 3: Governance**

| Level | Criteria |
|---|---|
| Crawl | No formal process, reactive cost management, no RACI |
| Walk | Monthly reviews, basic budget alerts, RACI defined, weekly tactical reviews |
| Run | Full cadence (daily/weekly/monthly/quarterly), automated enforcement, OKRs tracked |

**Dimension 4: Automation**

| Level | Criteria |
|---|---|
| Crawl | Manual processes, no policy-as-code, no automated alerts |
| Walk | SCPs enforced, Config Rules active, basic Lambda remediation, budget alerts |
| Run | Full policy-as-code, Infracost in CI/CD, automated remediation, self-healing |

**Dimension 5: Culture**

| Level | Criteria |
|---|---|
| Crawl | Only finance cares about cloud costs, engineers unaware of cost impact |
| Walk | Engineering managers have cost visibility, basic team accountability |
| Run | Every engineer sees cost impact per deploy, FinOps embedded in sprint planning |

### LendFlow Maturity Scorecard

| Dimension | Current | 30-Day Target | 90-Day Target |
|---|---|---|---|
| Visibility | 🔴 Crawl | 🟡 Walk | 🟢 Walk-Run |
| Optimisation | 🔴 Crawl | 🟡 Walk | 🟢 Walk-Run |
| Governance | 🔴 Crawl | 🟡 Walk | 🟢 Walk |
| Automation | 🔴 Crawl | 🟡 Walk | 🟢 Walk |
| Culture | 🔴 Crawl | 🔴 Crawl-Walk | 🟡 Walk |

---

## Continuous Improvement Cycle

PLAN

Define targets and OKRs for next quarter

Identify top optimisation opportunities

↓

DO

Execute optimisation recommendations

Implement governance controls

Activate policy-as-code

↓

CHECK

Weekly tactical reviews

Monthly operational reviews

Quarterly strategic reviews

Anomaly detection continuous

↓

ACT

Adjust targets based on results

Reprioritise backlog

Update runbooks and playbooks

Feed learnings back to PLAN

↑___________________________↑

---

## FinOps KPIs Dashboard

| KPI | Current | Target | Frequency | Owner |
|---|---|---|---|---|
| Monthly cloud cost | $180,000 | $115,000 | Monthly | FinOps Lead |
| Cost reduction % | 0% | 36% | Monthly | FinOps Lead |
| Tag compliance | 34% | 95% | Weekly | DevOps/SRE |
| RI/SP coverage | 12% | 75% | Monthly | FinOps Lead |
| RI utilisation | N/A | >85% | Monthly | FinOps Lead |
| Anomaly MTTD | 18 days | <4 hours | Continuous | DevOps/SRE |
| Cost/loan application | $0.00036 | $0.00022 | Monthly | FinOps Lead |
| Budget forecast accuracy | ±80% | ±15% | Monthly | Finance |
| P1 anomaly response rate | 0% | >99% | Monthly | DevOps/SRE |

---

*Prepared by Keerthi Kavuri | FinOps Engineer | June 2026*