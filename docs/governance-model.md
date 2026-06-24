# FinOps Governance Model — LendFlow Technologies
**Prepared by:** Keerthi Kavuri, FinOps Engineer  
**Date:** June 2026

---

## Overview

This document defines the FinOps governance model for LendFlow Technologies. Governance ensures that optimisation gains achieved in Month 1 do not silently erode by Month 6. The model covers team structure, RACI matrix, review cadences, budget governance hierarchy, and escalation paths.

**Core Principle:** Cost visibility and accountability must be embedded into daily engineering operations — not treated as a monthly finance exercise.

---

## FinOps Team Structure

### Roles & Responsibilities

| Role | Person | Responsibilities |
|---|---|---|
| FinOps Lead | Keerthi Kavuri | Cost analysis, recommendations, governance, reporting |
| Engineering Sponsor | Arjun Deshmukh (CTO) | Executive buy-in, architectural decisions |
| Finance Partner | Priya Menon (CFO) | Budget ownership, chargeback decisions |
| Engineering Champions | Team leads (each BU) | Team-level cost accountability |
| DevOps/SRE | Platform Infra team | Policy implementation, automation |

---

## RACI Matrix

| Activity | FinOps Lead | Eng Manager | CFO | Product Owner | DevOps/SRE |
|---|---|---|---|---|---|
| Set annual cloud budget | C | C | A/R | C | I |
| Monthly cost review | R | C | A | I | C |
| Right-sizing recommendations | A | R | I | I | R |
| Reserved capacity purchasing | R | C | A | I | C |
| Tag compliance enforcement | A/R | R | I | I | R |
| Cost anomaly investigation | A | R | I | I | R |
| Architecture cost review | C | A/R | I | C | R |
| Quarterly strategic review | R | C | A | C | I |
| Spot instance strategy | C | C | I | I | A/R |
| Storage lifecycle policies | C | I | I | I | A/R |
| Dashboard maintenance | A/R | I | I | I | C |
| SCP policy management | A | C | I | I | R |

**R = Responsible | A = Accountable | C = Consulted | I = Informed**

---

## Review Cadences

### Daily Automated Check
| Attribute | Detail |
|---|---|
| Frequency | Daily (automated — no meeting) |
| Participants | FinOps Lead (reviews output), On-call SRE |
| Tool | AWS Cost Anomaly Detection + CloudWatch dashboard |
| Agenda | Anomaly alerts, budget burn rate, cost per hour trend |
| Output | Anomaly tickets raised, immediate action items assigned |
| Time Commitment | 15 minutes review by FinOps Lead |

### Weekly Tactical Review
| Attribute | Detail |
|---|---|
| Frequency | Every Monday 10:00 AM IST |
| Duration | 45 minutes |
| Participants | FinOps Lead, Engineering Leads, On-call SRE |
| Agenda | Week-over-week cost changes, right-sizing queue progress, spot interruption rates, anomaly follow-ups |
| Output | Updated optimisation task backlog, assigned action items |
| Decision Authority | FinOps Lead for tactical optimisations |

**Weekly Review Agenda Template:**

Cost delta vs last week (5 min)
Open anomaly tickets review (10 min)
Right-sizing progress update (10 min)
Tag compliance scorecard (5 min)
Upcoming week priorities (10 min)
Action items and owners (5 min)

### Monthly Operational Review
| Attribute | Detail |
|---|---|
| Frequency | First Tuesday of each month, 2:00 PM IST |
| Duration | 2 hours |
| Participants | FinOps Lead, All Engineering Managers, Finance representative |
| Agenda | Month-end actuals vs budget, unit economics trends, tag compliance, optimisation achievements, forecast update |
| Output | Monthly cost report, updated 3-month forecast, optimisation backlog reprioritisation |
| Decision Authority | Engineering Managers for team-level commitments, FinOps Lead for recommendations |

### Quarterly Strategic Review
| Attribute | Detail |
|---|---|
| Frequency | First week of each quarter |
| Duration | Half day |
| Participants | CFO, CTO, FinOps Lead, Product Heads |
| Agenda | RI/SP purchase decisions, architecture investment cases, annual budget reforecast, maturity assessment |
| Output | RI/SP purchase orders, strategic roadmap updates, budget reallocation decisions |
| Decision Authority | CFO for financial commitments, CTO for architectural direction |

**Quarterly Review Agenda Template:**

Morning Session (3 hours):

Previous quarter actuals vs targets (30 min)
Unit economics evolution (30 min)
RI/SP portfolio performance + renewal decisions (45 min)
Maturity assessment: Crawl/Walk/Run progress (30 min)
Architecture investment cases (45 min)

Afternoon Session (1 hour):

6. Next quarter budget and targets (30 min)

7. Strategic decisions and approvals (30 min)

---

## Budget Governance Hierarchy

### Organisation Budget Structure

Organisation Total: $180,000/month (current) → $115,000/month (target)

│

├── Lending Business Unit: $90,000/month

│   ├── Loan Origination Team: $30,000

│   │   Alert at: $24,000 (80%), $27,000 (90%), $30,000 (100%)

│   ├── Credit Scoring Team: $25,000

│   │   Alert at: $20,000 (80%), $22,500 (90%), $25,000 (100%)

│   └── Document Processing Team: $35,000

│       Alert at: $28,000 (80%), $31,500 (90%), $35,000 (100%)

│

├── Payments Business Unit: $45,000/month

│   ├── Payment Gateway Team: $30,000

│   │   Alert at: $24,000 (80%), $27,000 (90%), $30,000 (100%)

│   └── Fraud Detection Team: $15,000

│       Alert at: $12,000 (80%), $13,500 (90%), $15,000 (100%)

│

└── Platform Business Unit: $45,000/month

├── Platform Infra Team: $25,000

│   Alert at: $20,000 (80%), $22,500 (90%), $25,000 (100%)

└── Data Engineering Team: $20,000

Alert at: $16,000 (80%), $18,000 (90%), $20,000 (100%)

### Budget Alert Thresholds & Actions

| Threshold | Notification | Automated Action | Manual Action |
|---|---|---|---|
| 80% of budget | Slack #finops-alerts to FinOps Lead + Team Lead | Dashboard flag | Team lead investigates variance |
| 90% of budget | Email to Engineering Manager + FinOps Lead | PagerDuty alert | Manager approval required for new resources |
| 100% of budget | PagerDuty to VP Engineering + CFO | SNS alert to all stakeholders | Executive review within 4 hours |
| 120% of budget | PagerDuty + SMS to CFO + CTO | SCP: Block new resource creation | Emergency war room within 1 hour |

---

## Escalation Matrix

### Cost Overrun Escalation

| Level | Trigger | Response Time | Escalation Path |
|---|---|---|---|
| Team | Team budget > 100% | 4 hours | Team Lead → FinOps Lead |
| Business Unit | BU budget > 100% | 2 hours | Eng Manager → FinOps Lead → CTO |
| Organisation | Total > 100% budget | 1 hour | FinOps Lead → CFO → CTO |
| Emergency | Total > 120% budget | 30 minutes | CFO + CTO + CEO |

### Anomaly Escalation

| Severity | Response SLA | Escalation Path |
|---|---|---|
| P1 Critical (>200% daily baseline) | 30 minutes | FinOps Lead → CTO → CFO |
| P2 High (>150% daily baseline) | 4 hours | FinOps Lead → Engineering Manager |
| P3 Medium (>120% weekly forecast) | 24 hours | FinOps Lead review in weekly meeting |
| P4 Low (5–20% above baseline) | Next review cycle | Added to optimisation backlog |

---

## FinOps KPIs & OKRs

### Key Performance Indicators

| KPI | Current | 30-Day Target | 90-Day Target | Owner |
|---|---|---|---|---|
| Monthly Cloud Cost | $180,000 | $155,000 | $115,000 | FinOps Lead |
| Cost Reduction % | 0% | 14% | 36% | FinOps Lead |
| Tag Compliance | 34% | 70% | 95% | DevOps/SRE |
| RI/SP Coverage | 12% | 40% | 75% | FinOps Lead |
| Anomaly Detection Time | 18 days | 4 hours | 1 hour | DevOps/SRE |
| Cost per Loan Application | $0.00036 | $0.00028 | $0.00022 | FinOps Lead |
| RI Utilisation Rate | N/A | N/A | >85% | FinOps Lead |
| Budget Forecast Accuracy | ±80% | ±30% | ±15% | Finance |

### Quarterly OKRs

**Q3 2026 OKRs:**
- **O1:** Achieve $60,000+/month cost reduction
  - KR1: Complete EC2 right-sizing for 40+ instances by Week 6
  - KR2: Purchase 52 Reserved Instances by Week 5
  - KR3: Schedule dev/staging shutdown by Week 2
- **O2:** Establish FinOps visibility foundation
  - KR1: Tag compliance from 34% to 95% by Day 90
  - KR2: Anomaly detection time from 18 days to <4 hours by Day 30
  - KR3: All 3 cost dashboards live by Day 30
- **O3:** Embed governance into daily operations
  - KR1: Weekly tactical reviews established and attended by all leads
  - KR2: SCP enforcement active by Day 60
  - KR3: Monthly cost report distributed by end of each month

---

## Governance Maturity Roadmap

| Dimension | Current (Crawl) | 30 Days (Crawl→Walk) | 90 Days (Walk) |
|---|---|---|---|
| Visibility | 34% tags, no dashboards | 70% tags, dashboards live | 95% tags, unit economics tracked |
| Optimisation | 12% RI, no right-sizing | RIs purchased, dev right-sized | All environments right-sized |
| Governance | No formal process | Weekly reviews established | Full cadence running |
| Automation | No policy-as-code | SCPs active, Config Rules live | Full remediation automation |
| Culture | Cost invisible to engineers | Managers have visibility | Engineers see cost per deploy |

---

*Prepared by Keerthi Kavuri | FinOps Engineer | June 2026*