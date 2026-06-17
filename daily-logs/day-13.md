# Day 13 — CFO Presentation Preparation
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Full Day — CFO Review Panel Presentation

### Presentation Structure (18 Slides)

**Slide 1: Title**
LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework
90-Day Plan to Recover $65,000+/Month

**Slide 2: Executive Summary**
- Problem: AWS bill grew 260% in 12 months, revenue only doubled
- Analysis: $77,800/month in identified waste across 8 categories
- Solution: Phased FinOps framework delivering $65,000–$70,000/month savings
- Ask: Approval to proceed with 90-day implementation plan

**Slide 3: The Problem — Cost vs Revenue Growth**
- Chart: Monthly AWS spend vs Monthly Revenue (12 months)
- Key stat: Cloud cost as % of revenue grew from 10% to 18%
- Key stat: Gross margin eroded from 75% to 55%
- Headline: "We are spending 3.6x more on infrastructure per dollar of revenue than 12 months ago"

**Slide 4: Where Is the Money Going?**
- Pie chart: Cost breakdown by category (Compute 51%, Database 21%, Transfer 11%, Storage 10%, Other 7%)
- Trend lines: Compute +58%, Database +72%, Data Transfer +137%
- Callout: Data transfer grew 137% — fastest growing, most architectural in nature

**Slide 5: Root Causes — 8 Categories of Waste**
- Bar chart: Waste by category with dollar amounts
- Total addressable: $77,800/month
- Compliance-protected: $10,100/month (non-negotiable)
- Net recoverable: $67,700/month

**Slide 6: Quick Wins (Week 1–2) — $18,000/Month**
- Delete 200+ unattached EBS volumes: $1,800/month
- Clean up 847 orphaned snapshots: $1,800/month
- Schedule dev/staging shutdown (7PM-9AM + weekends): $13,000/month
- Deploy VPC Endpoints (eliminate internet egress): $2,000/month
- Risk: LOW — zero production impact

**Slide 7: Medium-Term Optimisations (Weeks 3–8) — $32,000/Month**
- Purchase Reserved Instances (75% coverage): $16,000/month
- Right-size 40+ over-provisioned instances: $11,000/month
- Implement spot instances for CI/CD and ML: $5,000/month
- Risk: MEDIUM — requires testing and validation

**Slide 8: Long-Term Strategy (Weeks 9–12+) — $15,000/Month**
- Fix cross-AZ data transfer (architectural change): $7,000/month
- S3 storage lifecycle policies: $5,000/month
- Database right-sizing and Aurora Serverless migration: $3,000/month
- Risk: MEDIUM-HIGH — architectural changes require careful testing

**Slide 9: Compliance Guardrails**
- PCI DSS: Payment gateway instances untouched ($4,200/month protected)
- SOC 2: Audit logs excluded from lifecycle policies ($3,100/month protected)
- RBI IT: Multi-AZ minimums enforced ($2,800/month protected)
- GDPR: EU data stays in EU regions (no cross-region arbitrage)
- Message: Every recommendation has been compliance-reviewed

**Slide 10: Risk Assessment**

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Right-sizing causes performance degradation | Low | High | Canary deployment, 2-week monitoring |
| Spot interruptions affect batch processing | Medium | Low | SQS queue-based architecture |
| RI over-commitment if growth changes | Low | Medium | Convertible RIs allow exchange |
| Dev env scheduling blocks emergency access | Low | Medium | On-call override procedure |

**Slide 11: FinOps Governance Framework**
- RACI matrix: Clear ownership for every FinOps activity
- Review cadences: Daily automated → Weekly tactical → Monthly operational → Quarterly strategic
- Budget hierarchy: Org → Business Unit → Team → Project
- Policy-as-code: SCPs prevent future governance failures

**Slide 12: 90-Day Implementation Gantt**

| Week | Actions |
|---|---|
| Week 1-2 | Quick wins: EBS cleanup, snapshot deletion, dev env scheduling, VPC Endpoints |
| Week 3-4 | RI purchase, begin right-sizing (dev/staging first) |
| Week 5-6 | Right-sizing production (with monitoring), spot implementation |
| Week 7-8 | Data transfer architectural fixes, storage lifecycle policies |
| Week 9-10 | Database optimisation, anomaly detection framework deployment |
| Week 11-12 | Governance automation (SCPs, Config Rules), dashboard deployment |

**Slide 13: Projected Financial Impact**

| Month | Cumulative Savings | AWS Bill |
|---|---|---|
| Month 1 (Quick Wins) | $18,000 | $162,000 |
| Month 2 (Optimisations) | $50,000 | $130,000 |
| Month 3 (Full Framework) | $65,000–$70,000 | $110,000–$115,000 |
| Month 6 (Sustained) | $67,000–$72,000 | $108,000–$113,000 |
| **Annual Savings** | **$804,000** | |

**Slide 14: Return on FinOps Investment**

| Cost | Amount |
|---|---|
| FinOps Lead time (3 months) | $45,000 |
| Tooling (Grafana, CloudHealth) | $3,600/year |
| Implementation effort (engineering) | $30,000 |
| **Total Investment** | **$78,600** |
| **Annual Savings** | **$804,000** |
| **ROI** | **922%** |
| **Payback Period** | **35 days** |

**Slide 15: Key Metrics & KPIs**

| Metric | Today | 90-Day Target | 12-Month Target |
|---|---|---|---|
| Monthly AWS Spend | $180,000 | $115,000 | $100,000 |
| Cost Per Loan Application | $0.00036 | $0.00022 | $0.00016 |
| RI/SP Coverage | 12% | 75% | 80% |
| Tag Compliance | 34% | 90% | 97% |
| Anomaly Detection Time | 18 days | <4 hours | <1 hour |

**Slide 16: Series B Readiness**
- Investors scrutinise unit economics and infrastructure efficiency
- Current: $0.00036 per loan application (industry benchmark: $0.00015–$0.00020)
- Post-FinOps: $0.00022 per loan application (within benchmark range)
- Cloud cost as % of revenue: 18% → 11.5% → 8% (benchmark: <10%)
- Message: FinOps framework is a Series B readiness initiative, not just cost-cutting

**Slide 17: The Ask**
- Approval to proceed with 90-day FinOps implementation plan
- Budget approval: $78,600 total investment
- Engineering capacity: 2 person-weeks for right-sizing validation
- Governance: Monthly CFO review meeting for first 6 months

**Slide 18: Q&A**
Anticipated questions and answers prepared in speaker notes.

---

## Speaker Notes — Anticipated CFO Questions

**Q: What is your confidence level in the $65,000/month projection?**
A: High confidence (85%+) on quick wins ($18,000) — these are mechanical cleanups with no dependencies. Medium confidence (70%) on optimisation phase ($32,000) — right-sizing requires performance validation. The conservative scenario of $61,000/month still exceeds the target.

**Q: What happens if we only achieve 50% of projected savings?**
A: Even at 50%, we save $32,500/month — $390,000 annually. Still a 922% ROI on the $78,600 investment. The program pays for itself in the first month of quick wins alone.

**Q: How do we ensure compliance is maintained?**
A: Every recommendation has been reviewed against PCI DSS, SOC 2, RBI IT, and GDPR. Compliance-constrained resources ($10,100/month) are explicitly excluded. The Head of Compliance (Meera Iyer) has a veto role in the RACI matrix.

**Q: What is the risk to platform availability?**
A: Near-zero for quick wins (cleanup of unused resources). Low for right-sizing (canary deployments, 2-week monitoring periods). Medium for architectural changes (data transfer fixes) — these are scheduled during low-traffic windows.

**Q: What resources do you need?**
A: FinOps Lead (existing role), 2 person-weeks engineering capacity for right-sizing validation, $3,600/year tooling budget. No new headcount required.

---

## Key Learnings Today
1. CFO presentation must tell a story — problem → analysis → solution → ask
2. ROI framing (922%, 35-day payback) is more persuasive than raw savings numbers
3. Series B readiness angle connects FinOps to strategic business goals — not just ops efficiency
4. Anticipated Q&A preparation is as important as the slides themselves

---

## Tomorrow's Plan
- Cross-reference all savings figures across all documents
- Proofread all documents for consistency
- Update README.md with final navigation
- Verify GitHub repository structure matches prescribed layout exactly