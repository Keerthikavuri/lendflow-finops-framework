# Day 01 — FinOps Foundations & Dataset Familiarisation
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Morning Session — Research & Framework Study

### FinOps Foundation Framework
Studied the FinOps Foundation's three iterative phases:

**Phase 1: Inform**
- Cost allocation tagging to map every resource to business unit, product, environment
- Showback/chargeback models for financial transparency across teams
- Real-time dashboards using AWS Cost Explorer, CloudHealth, Kubecost
- Anomaly detection establishing baseline spending patterns
- Unit economics: cost-per-transaction, cost-per-loan-disbursement

**Phase 2: Optimise**
- Right-sizing: analyse CPU/memory/network utilisation to downsize over-provisioned instances
- Reserved Instances and Savings Plans: 30–72% discounts for 1–3 year commitments
- Spot instances: 60–90% savings for fault-tolerant workloads
- Storage tier optimisation: lifecycle policies for S3 Standard → IA → Glacier transitions
- Idle resource elimination: unused EBS volumes, unattached Elastic IPs, idle load balancers

**Phase 3: Operate**
- Automated scaling policies matching capacity to demand
- Budget governance with hierarchical thresholds and escalation actions
- Policy-as-code: AWS Config Rules, OPA, Sentinel policies
- Continuous right-sizing as workload patterns evolve

### AWS Well-Architected Cost Optimisation Pillar — 5 Design Principles
1. Implement cloud financial management
2. Adopt a consumption model
3. Measure overall efficiency
4. Stop spending money on undifferentiated heavy lifting
5. Analyse and attribute expenditure

### 9 Best Practices Studied
1. Practice cloud financial management
2. Govern usage
3. Monitor cost and usage
4. Decomission resources
5. Select the right resource type/size
6. Select the right pricing model
7. Plan for data transfer charges
8. Manage demand and supply resources
9. Optimize over time

---

## Afternoon Session — Dataset Analysis & Repository Setup

### LendFlow Technologies — Stakeholder Priority Matrix

| Persona | Role | Priority | Potential Conflict |
|---|---|---|---|
| Priya Menon | CFO | Reduce spend 33%+ in 90 days | May push overly aggressive cuts |
| Arjun Deshmukh | CTO | Maintain 99.95% SLA | Resistant to operational overhead |
| Ravi Krishnan | VP Engineering | Ship features on schedule | Opposes mandatory tagging |
| Meera Iyer | Head of Compliance | Zero audit findings | Blocks anything risking compliance |
| Sanjay Patel | Head of Data Engineering | ML training throughput | Wants expensive GPU instances |
| Anita Sharma | Product Manager | Launch products on time | Opposes dev environment limits |

### Monthly Cost Summary — Initial EDA Findings

| Month | Total Spend | MoM Growth | Budget Variance |
|---|---|---|---|
| Month 1 | $125,000 | baseline | +25% over budget |
| Month 2 | $138,000 | +10.4% | +38% over budget |
| Month 3 | $149,000 | +8.0% | +49% over budget |
| Month 4 | $158,000 | +6.0% | +58% over budget |
| Month 5 | $169,000 | +7.0% | +69% over budget |
| Month 6 | $180,000 | +6.5% | +80% over budget |

### Fastest Growing Cost Categories (Month 1 → Month 6)
1. **Compute (EC2/EKS):** $58,000 → $92,000 (+58%) — largest absolute increase
2. **Database (RDS/ElastiCache):** $22,000 → $38,000 (+72%) — fastest growth rate
3. **Data Transfer:** $8,000 → $19,000 (+137%) — most alarming growth signal
4. **Storage (S3/EBS):** $14,000 → $18,000 (+28%) — steady accumulation
5. **Networking (ELB/NAT):** $6,000 → $8,000 (+33%) — overlooked category

### Key Questions Identified for Investigation
- Which specific EC2 instances are driving the compute spike?
- Are development environments running 24/7?
- What is causing the 137% data transfer increase?
- What is the current Reserved Instance coverage percentage?
- How many resources are untagged (dark spend)?

---

## Repository Setup Completed
- GitHub repository `lendflow-finops-framework` initialised
- All prescribed directories created: docs/, analysis/, dashboards/, policies/, presentation/, daily-logs/
- README.md and CHANGELOG.md committed
- Initial commit pushed to main branch

---

## Key Learnings Today
1. FinOps is a cultural practice, not just a technical tool — requires cross-functional alignment
2. Visibility must precede optimisation — cannot fix what you cannot measure
3. Compliance constraints are non-negotiable guardrails, not afterthoughts
4. LendFlow's data transfer growth (137%) is the most alarming signal — likely architectural issue
5. At $180,000/month with 34% tag compliance, a significant portion of spend is "dark" — unattributable

---

## Tomorrow's Plan
- Deep-dive instance_utilisation.csv — identify all instances below 20% CPU
- Analyse database instances for right-sizing opportunities
- Begin savings model: Compute + Database tabs