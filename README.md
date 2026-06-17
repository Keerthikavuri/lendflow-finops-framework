# LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

**ZeTheta WorkBridge Program | Project 1C | DevOps & Cloud Engineer**  
**Intern:** Keerthi Kavuri  
**Timeline:** 15 Days  
**Target:** 33%+ cost reduction ($60,000+/month savings) for LendFlow Technologies

---

## Executive Summary

LendFlow Technologies, a fictional cloud-native fintech company, saw its AWS monthly bill escalate from **$50,000 to $180,000** over 12 months while revenue only doubled. This project delivers a comprehensive **Infrastructure Cost Optimisation and FinOps Framework** implementing the full Inform → Optimise → Operate lifecycle to achieve a minimum **$60,000/month cost reduction** without degrading platform performance or breaching PCI DSS, SOC 2, RBI IT Framework, or GDPR compliance obligations.

### Key Findings
| Category | Monthly Waste Identified | Savings Potential |
|---|---|---|
| Over-provisioned Compute (EC2/EKS) | ~$22,000 | $18,000–$22,000 |
| Idle Dev/Staging Environments | ~$15,000 | $12,000–$15,000 |
| Missing Reserved Instance Coverage | ~$18,000 | $15,000–$20,000 |
| Unoptimised Storage Tiers (S3/EBS) | ~$8,000 | $6,000–$8,000 |
| Excessive Cross-AZ Data Transfer | ~$9,000 | $6,000–$9,000 |
| Orphaned Snapshots & Idle Resources | ~$5,000 | $4,000–$5,000 |
| **Total Addressable Savings** | **~$77,000** | **$61,000–$79,000** |

**Projected Monthly Savings: $65,000–$70,000 (36–39% reduction)**

---

## Repository Structure

lendflow-finops-framework/

├── README.md

├── CHANGELOG.md

├── docs/

│   ├── cost-audit-report.md

│   ├── optimisation-recommendations.md

│   ├── auto-scaling-policies.md

│   ├── ri-spot-strategy.md

│   ├── tagging-taxonomy.md

│   ├── governance-model.md

│   ├── anomaly-detection.md

│   └── review-process.md

├── analysis/

├── dashboards/

├── policies/

├── presentation/

└── daily-logs/

---

## FinOps Methodology

### Phase 1: Inform (Days 1–5)
- Complete cloud cost audit across all 8 simulated datasets
- Tag compliance analysis and taxonomy design
- Cost anomaly identification and pattern analysis
- Baseline unit economics calculation

### Phase 2: Optimise (Days 6–10)
- Right-sizing recommendations for 40+ over-provisioned instances
- Reserved Instance / Savings Plan procurement strategy
- Spot instance architecture for fault-tolerant workloads
- Storage lifecycle policy design and data transfer optimisation
- Auto-scaling policy specifications for 6 service types

### Phase 3: Operate (Days 11–15)
- FinOps governance model with RACI matrix
- Cost anomaly detection and alerting framework
- Policy-as-code (SCPs, Config Rules, Terraform modules)
- CFO-ready 90-day implementation roadmap
- Cost dashboards for 3 audience levels

---

## Compliance Framework

| Framework | Key Constraint | Impact |
|---|---|---|
| PCI DSS v4.0 | Payment infra must stay isolated | Limits compute consolidation |
| SOC 2 Type II | Audit logs retained 12+ months | Limits storage lifecycle |
| RBI IT Framework | Multi-AZ minimum replicas enforced | Enforces minimum instance counts |
| GDPR | EU data must stay in EU regions | Restricts cross-region arbitrage |

---

## Tools Used

- **Analysis:** Microsoft Excel (pivot tables, savings modelling)
- **Diagrams:** Draw.io (architecture diagrams, dashboard mockups)
- **IaC & Policies:** Terraform HCL, AWS SCP JSON, OPA Rego
- **Version Control:** Git + GitHub
- **AI Research Assistance:** Claude.ai (research, document drafting)
- **Reference:** AWS Pricing Calculator, FinOps Foundation Framework

---

