# Day 10 — Cost Dashboard Design & Mockups
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Full Day — Dashboard Design

### Dashboard 1: Executive Dashboard (CFO/CTO)

**Audience:** Priya Menon (CFO), Arjun Deshmukh (CTO)
**Refresh Frequency:** Daily (automated)
**Access:** C-suite + FinOps Lead only

| Widget # | Widget Name | Metric | Purpose |
|---|---|---|---|
| 1 | Monthly Spend Gauge | $X of $120,000 budget | Instant budget status |
| 2 | Cost vs Revenue Trend | 12-month rolling chart | Efficiency narrative |
| 3 | Budget vs Actual | Variance by business unit | Accountability |
| 4 | Cost Per Transaction | $0.00018 today vs $0.0002 baseline | Unit economics |
| 5 | MoM Change % | +/-X% vs last month | Trend direction |
| 6 | Top 5 Services by Cost | Ranked bar chart | Focus areas |
| 7 | 3-Month Forecast | Projected spend with confidence band | Planning |
| 8 | RI/SP Coverage Ratio | 75% covered / 25% on-demand | Commitment health |
| 9 | Savings Realised YTD | $X saved since FinOps program start | ROI proof |
| 10 | Compliance Status | Green/Amber/Red per framework | Risk overview |

**Key Insight This Dashboard Surfaces:**
Are we on track to meet the $60,000/month savings target within 90 days?

---

### Dashboard 2: Engineering Manager Dashboard

**Audience:** Ravi Krishnan (VP Eng), Team Engineering Managers
**Refresh Frequency:** Hourly
**Access:** Engineering managers + FinOps Lead

| Widget # | Widget Name | Metric | Purpose |
|---|---|---|---|
| 1 | Team Spend Breakdown | Cost by team (bar chart) | Team accountability |
| 2 | CPU Utilisation Heatmap | Instance utilisation matrix | Right-sizing visibility |
| 3 | Memory Utilisation Heatmap | Memory usage by instance | Right-sizing visibility |
| 4 | Right-Sizing Opportunity Queue | Instances + estimated savings | Action queue |
| 5 | Tag Compliance Scorecard | % by team (RAG status) | Governance pressure |
| 6 | Anomaly Alert Feed | Last 7 days alerts with status | Operational awareness |
| 7 | RI Coverage by Instance Family | Coverage % per family | Commitment gaps |
| 8 | Spot vs On-Demand Mix | % split by workload | Cost mix health |
| 9 | Dev/Staging Schedule Compliance | Are envs shutting down on time? | Waste prevention |
| 10 | Week-over-Week Cost Delta | +/-% by service | Trend awareness |

**Key Insight This Dashboard Surfaces:**
Which teams are driving cost increases and what specific actions will reduce them?

---

### Dashboard 3: Team/Developer Dashboard

**Audience:** Individual engineering teams (lending-backend, data-engineering, etc.)
**Refresh Frequency:** Real-time (15-minute delay)
**Access:** All engineers (read-only), team leads (can acknowledge alerts)

| Widget # | Widget Name | Metric | Purpose |
|---|---|---|---|
| 1 | My Service Cost Today | $X today vs $Y yesterday | Daily awareness |
| 2 | Cost Per Deployment | Delta cost per git push | Developer accountability |
| 3 | Scaling Event Log | Scale-out/in events last 24h | Understanding cost drivers |
| 4 | Idle Resource Alerts | Unattached volumes, idle LBs | One-click remediation |
| 5 | Cost Per API Endpoint | Top 10 most expensive endpoints | Optimisation targets |
| 6 | Daily Cost Trend | 30-day cost chart with anomalies | Pattern recognition |
| 7 | Tag Compliance Score | My team's compliance % | Personal accountability |
| 8 | Spot Interruption Log | Interruptions last 7 days | Reliability awareness |
| 9 | Storage Cost Breakdown | S3 + EBS by service | Storage waste visibility |
| 10 | Weekly Budget Burn Rate | % of weekly budget consumed | Pacing awareness |

**Key Insight This Dashboard Surfaces:**
What did my team's deployments and code changes cost today, and what can I fix right now?

---

## Dashboard Technical Specifications

### Data Sources
| Source | Data Provided | Latency |
|---|---|---|
| AWS Cost and Usage Report (CUR) | Granular cost data | 24 hours |
| AWS Cost Explorer API | Service-level costs | 24 hours |
| CloudWatch Metrics | CPU, memory, request count | Real-time |
| AWS Cost Anomaly Detection | Anomaly events | <4 hours |
| Custom Lambda (tag compliance) | Tag compliance scores | Daily |
| AWS Compute Optimizer | Right-sizing recommendations | Daily |

### Tooling Recommendation
- **Executive Dashboard:** AWS Cost Explorer + QuickSight
- **Engineering Manager Dashboard:** Grafana + CloudWatch + CUR data via Athena
- **Team Dashboard:** Grafana + CloudWatch (real-time metrics)
- **Alternative:** CloudHealth or Spot.io for unified multi-dashboard view

---

## Key Learnings Today
1. Three different audiences need fundamentally different dashboards — one-size-fits-all fails
2. Developer dashboard with cost-per-deployment creates cultural cost accountability
3. Tag compliance scorecard in engineering manager view creates peer pressure for governance
4. Real-time team dashboard requires CloudWatch — CUR data is too delayed (24 hours)

---

## Tomorrow's Plan
- Design monthly FinOps report template
- Design quarterly strategic review package
- Create FinOps maturity assessment framework (Crawl/Walk/Run)
- Define KPIs and OKRs for FinOps function