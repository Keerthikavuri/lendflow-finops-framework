# Day 11 — FinOps Review Process & Reporting
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Full Day — Review Process & Maturity Framework

### Monthly FinOps Report Template

**Section 1: Executive Summary (1 paragraph)**
Month X cloud spend was $[X] against a budget of $[Y], a variance of [+/-Z%]. The [largest/smallest] variance was in [service/team] due to [reason]. Total savings realised this month: $[X]. YTD savings: $[X] against target of $[X].

**Section 2: Budget vs Actual Analysis**

| Business Unit | Budget | Actual | Variance | Explanation |
|---|---|---|---|---|
| Lending | $55,000 | $X | +/-% | [reason if >10% variance] |
| Payments | $35,000 | $X | +/-% | [reason if >10% variance] |
| Shared Services | $30,000 | $X | +/-% | [reason if >10% variance] |
| **Total** | **$120,000** | **$X** | **+/-%** | |

**Section 3: Top Cost Drivers**
- Top 5 by absolute spend this month
- Top 5 by growth rate vs last month

**Section 4: Optimisation Achievements**
- Savings realised this month (by category)
- Optimisation tasks completed
- Tag compliance improvement

**Section 5: Upcoming Actions (Prioritised Backlog)**
- Next 4 weeks optimisation roadmap
- Owner assigned for each action item

**Section 6: Risk Items**
- Budget overrun risks (services trending above budget)
- Expiring Reserved Instances (next 90 days)
- Upcoming compliance audits

---

### Quarterly Strategic Review Package

**Slide 1:** 12-month cost trend with annotated milestones
- FinOps program start date marked
- Major optimisation completions marked
- Anomaly events marked

**Slide 2:** Unit Economics Evolution
- Cost-per-loan-application trending (target: 45% reduction)
- Cost-per-active-user trending
- Cloud cost as % of revenue trending (target: <8%)

**Slide 3:** RI/SP Portfolio Performance
- Coverage % achieved vs target (75%)
- Savings realised vs projected
- Upcoming expirations requiring renewal decision

**Slide 4:** Architecture Investment Cases
- Graviton migration ROI analysis (20-40% additional compute savings)
- Containerisation (EKS) cost impact assessment
- Multi-region DR cost implications

**Slide 5:** FinOps Maturity Progress
- Current maturity level per dimension
- Targets for next quarter

---

### FinOps Maturity Assessment Framework

| Dimension | Crawl | Walk | Run |
|---|---|---|---|
| **Visibility** | Manual monthly bill review only | Real-time dashboards for engineering managers | Per-deployment cost visibility, unit economics per API endpoint |
| **Optimisation** | Ad-hoc right-sizing when notified | Systematic right-sizing quarterly review | Continuous automated right-sizing with ML recommendations |
| **Governance** | No formal ownership or process | RACI defined, monthly reviews established | Policy-as-code enforcement, automated budget guardrails |
| **Automation** | All actions manual | Scheduled shutdowns, lifecycle policies automated | Full anomaly-to-remediation automation, self-healing policies |
| **Culture** | Cost is ops team's problem | Engineering managers have cost KPIs | Every developer sees cost impact of their deployments |

**LendFlow Current State:** Crawl across all 5 dimensions
**Target at 90 days:** Walk across Visibility, Governance, Automation; Crawl→Walk on Culture
**Target at 12 months:** Run across Visibility and Optimisation; Walk on remaining dimensions

---

### FinOps KPIs and OKRs

| KPI | Current | 90-Day Target | 12-Month Target |
|---|---|---|---|
| Monthly cloud spend | $180,000 | $115,000 | $100,000 |
| Cost reduction % | 0% | 36% | 44% |
| Cost-per-loan-application | $0.00036 | $0.00022 | $0.00016 |
| Tag compliance | 34% | 90% | 97% |
| RI/SP coverage | 12% | 75% | 80% |
| Anomaly MTTD | 18 days | <4 hours | <1 hour |
| RI utilisation | N/A | >85% | >90% |
| Cloud cost as % revenue | 18% | 11.5% | 8% |

---

## Key Learnings Today
1. Maturity model prevents treating FinOps as a one-time project — it is a continuous journey
2. Unit economics (cost-per-transaction) is more meaningful to CFO than raw infrastructure cost
3. Culture dimension is hardest to move — requires developer tooling, not just process
4. Quarterly RI review is critical — expiring RIs without renewal = instant cost spike

---

## Tomorrow's Plan
- Write SCP JSON policy files (4+ policies)
- Design AWS Config Rules for tag compliance and utilisation monitoring
- Create Terraform module template with cost-aware validation
- Design automated remediation workflow