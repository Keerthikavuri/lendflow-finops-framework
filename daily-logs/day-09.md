# Day 09 — FinOps Governance Model Design
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Full Day — Governance Model Design

### RACI Matrix — FinOps Activities

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
| Budget alert response | A/R | R | I | I | R |
| RI/SP purchase decisions | R | C | A | I | C |

*R=Responsible, A=Accountable, C=Consulted, I=Informed*

### Stakeholder Mapping to Governance Roles

| Persona | FinOps Role | Primary Responsibility |
|---|---|---|
| Priya Menon (CFO) | Executive Sponsor | Budget approval, quarterly strategic decisions |
| Arjun Deshmukh (CTO) | Technical Authority | Architecture cost decisions, SLA trade-offs |
| Ravi Krishnan (VP Eng) | Engineering Liaison | Team compliance, right-sizing approvals |
| Meera Iyer (Compliance) | Compliance Guardian | Veto on compliance-impacting optimisations |
| Sanjay Patel (Data Eng) | Workload Owner | Spot/batch cost ownership |
| Anita Sharma (Product) | Product Owner | Dev environment budget ownership |

---

## Review Cadences

### Daily Automated Check
- **Participants:** FinOps Lead (automated alerts), On-call SRE
- **Trigger:** Automated CloudWatch + AWS Cost Anomaly Detection
- **Agenda:** Anomaly alerts, budget burn rate, cost-per-hour trend
- **Output:** Anomaly tickets, immediate action items
- **Time:** Automated — no meeting required unless P1/P2 alert

### Weekly Tactical Review (Every Monday, 10 AM IST)
- **Participants:** FinOps Lead, Engineering Leads, SRE
- **Duration:** 45 minutes
- **Agenda:**
  - Week-over-week cost changes by service
  - Right-sizing queue review (new candidates identified)
  - Spot interruption rates and savings actualised
  - Tag compliance scorecard update
  - Optimisation task backlog prioritisation
- **Output:** Updated optimisation backlog, action items with owners

### Monthly Operational Review (First Monday of month, 2 PM IST)
- **Participants:** FinOps Lead, All Engineering Managers, Finance
- **Duration:** 90 minutes
- **Agenda:**
  - Month-end actuals vs budget by business unit
  - Unit economics trends (cost-per-loan-application)
  - Tag compliance report (teams below 95% flagged)
  - RI utilisation and coverage report
  - Savings realised vs projected (variance explanation)
- **Output:** Monthly cost report, updated forecasts, escalation notices

### Quarterly Strategic Review (First week of quarter, CFO-led)
- **Participants:** CFO, CTO, FinOps Lead, Product Heads
- **Duration:** 2 hours
- **Agenda:**
  - RI/SP purchase decisions for upcoming quarter
  - Architecture investment cases (Graviton migration ROI, containerisation)
  - Annual budget reforecast
  - FinOps maturity assessment update
  - 12-month cost trend with milestone annotations
- **Output:** Commitment purchase orders, strategic roadmap updates

---

## Budget Governance Hierarchy

### Hierarchy Structure

Organisation Budget: $120,000/month (target post-optimisation)

├── Lending Business Unit: $55,000

│   ├── Platform Infrastructure Team: $20,000

│   ├── Lending Backend Team: $22,000

│   └── Data Engineering Team: $13,000

├── Payments Business Unit: $35,000

│   ├── Payment Gateway Team: $20,000

│   └── Fraud Detection Team: $15,000

└── Shared Services: $30,000

├── DevOps/SRE: $15,000

└── Compliance Infrastructure: $15,000

### Alert Thresholds and Escalation Actions

| Threshold | Action | Notification | Escalation |
|---|---|---|---|
| 80% of budget | Warning alert | Team lead + FinOps Lead via Slack | Monitor daily |
| 90% of budget | Escalation alert | Engineering Manager + FinOps Lead | Review spend, identify actions |
| 100% of budget | Critical alert | VP Engineering + CFO | Approval required for new resources |
| 120% of budget | Emergency | CTO + CFO + automated throttling | Immediate containment actions |

---

## Key Learnings Today
1. RACI matrix prevents the most common governance failure — unclear ownership
2. Daily automated checks eliminate the 18-day detection lag seen in anomaly analysis
3. Budget hierarchy must mirror org structure — team-level budgets create accountability
4. Quarterly CFO review ties FinOps to business strategy, not just cost-cutting

---

## Tomorrow's Plan
- Design 3 cost dashboard mockups: Executive, Engineering Manager, Team level
- Document data sources, refresh frequencies, access permissions for each dashboard