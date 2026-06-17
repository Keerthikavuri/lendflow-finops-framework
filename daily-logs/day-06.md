# Day 06 — Cost Anomaly Analysis & Detection Framework
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Morning Session — Anomaly Event Analysis

### Cost Anomaly Events Summary (6 Months)

| # | Date | Service | Type | Expected | Actual | Variance | Root Cause |
|---|---|---|---|---|---|---|---|
| 1 | Month-1 Week-2 | EC2 | Scaling runaway | $8,000 | $18,400 | +130% | ASG max_capacity misconfigured |
| 2 | Month-1 Week-4 | RDS | Snapshot accumulation | $800 | $2,200 | +175% | No lifecycle policy |
| 3 | Month-2 Week-1 | Data Transfer | Cross-AZ spike | $3,000 | $7,800 | +160% | New service deployed cross-AZ |
| 4 | Month-2 Week-3 | S3 | Storage class drift | $1,200 | $3,100 | +158% | Lifecycle policy misconfigured |
| 5 | Month-3 Week-2 | Lambda | Invocation explosion | $400 | $3,200 | +700% | Infinite retry loop bug |
| 6 | Month-3 Week-4 | EC2 | Dev env left running | $2,000 | $6,800 | +240% | No scheduled shutdown |
| 7 | Month-4 Week-1 | NAT Gateway | Traffic spike | $1,800 | $4,400 | +144% | VPC Endpoint not configured |
| 8 | Month-4 Week-3 | ElastiCache | Cache miss storm | $600 | $2,100 | +250% | Cache warming failure |
| 9 | Month-5 Week-2 | EKS | Node scaling | $5,000 | $14,200 | +184% | Pod resource requests oversized |
| 10 | Month-5 Week-4 | CloudWatch | Log retention | $300 | $1,800 | +500% | No log retention policy |

### Anomaly Pattern Analysis

| Pattern | Frequency | Total Cost Impact | Prevention |
|---|---|---|---|
| Misconfigured auto-scaling | 3 occurrences | $28,400 | SCP + max instance limits |
| Missing lifecycle policies | 4 occurrences | $12,800 | Automated Config Rules |
| Dev environments running 24/7 | 5 occurrences | $18,600 | Scheduled shutdowns |
| No VPC Endpoints | 2 occurrences | $8,200 | Architecture enforcement |
| Application bugs (retry loops) | 1 occurrence | $3,200 | Budget alerts + anomaly detection |

**Total anomaly cost over 6 months: ~$71,200**
**Average detection time: 18 days (monthly bill review)**
**Target detection time: <4 hours (automated)**

---

## Afternoon Session — Detection Framework Design

### Multi-Layer Detection Architecture

**Layer 1 — Static Thresholds**
- Daily spend > 120% of 30-day rolling average → P3 alert
- Easy to implement, prone to false positives during legitimate scaling

**Layer 2 — Statistical Detection (Z-Score)**
- Calculate rolling 14-day mean and standard deviation
- Alert when daily spend > mean + 2 standard deviations
- More adaptive, slower to respond to gradual cost creep

**Layer 3 — ML-Based Detection (AWS Cost Anomaly Detection)**
- Trained on historical spending patterns per service
- Lower false-positive rate than static thresholds
- Monitors at account, service, and resource level simultaneously

**Layer 4 — Business Event Correlation**
- Integrated with deployment calendar and marketing campaign schedule
- Suppresses alerts during known high-spend events
- Flags unexpected spikes on non-event days

### Alert Severity Classification

| Severity | Trigger | Response SLA | Channel | Escalation |
|---|---|---|---|---|
| P1 Critical | Daily spend >200% baseline OR monthly projected >150% budget | 30 minutes | PagerDuty + SMS + Slack #finops-critical | FinOps Lead → CTO → CFO |
| P2 High | Daily spend >150% baseline OR new unbudgeted service | 4 hours | Slack #finops-alerts + Email | FinOps Lead → Eng Manager |
| P3 Medium | Weekly spend >120% forecast OR tag compliance <90% | 24 hours | Slack #finops-weekly + Dashboard | FinOps Lead weekly review |
| P4 Low | Minor drift 5-20% above baseline OR idle resource detected | Next review | Dashboard + Weekly report | Added to optimisation backlog |

### Anomaly Investigation Runbook Template

STEP 1 — TRIAGE (0-15 minutes)

□ Identify affected service from alert details

□ Check deployment calendar — was there a recent deployment?

□ Check marketing calendar — is there an active campaign?

□ Pull last 7 days of cost data for affected service

□ Classify: genuine anomaly vs expected scaling event
STEP 2 — ROOT CAUSE (15-60 minutes)

□ Check CloudWatch metrics: CPU, memory, request count

□ Check Auto Scaling activity log

□ Check CloudTrail for recent API calls (new resource launches)

□ Check application logs for error rates / retry loops

□ Identify specific resource IDs driving the cost spike
STEP 3 — CONTAINMENT (1-4 hours)

□ If runaway scaling: update ASG max_capacity, terminate excess instances

□ If infinite loop: disable Lambda trigger, fix application bug

□ If idle resources: schedule termination with team approval

□ If misconfiguration: apply correct config, document in CHANGELOG
STEP 4 — POST-INCIDENT (24-48 hours)

□ Calculate total financial impact of anomaly

□ Document root cause and timeline in incident report

□ Implement preventive control to avoid recurrence

□ Update anomaly detection thresholds if false positive

□ Present findings in next weekly FinOps review

---

## Key Learnings Today
1. Average anomaly detection time of 18 days (monthly bill) is unacceptable — automated detection needed
2. Misconfigured auto-scaling is the single most expensive anomaly pattern
3. Lambda infinite retry loop caused 700% cost spike — application bugs can be FinOps issues
4. Business event correlation is critical to avoid false positives during legitimate scaling

---

## Tomorrow's Plan
- Consolidate all analyses into comprehensive cost audit report
- Finalise savings model with Summary tab
- Write 15+ prioritised optimisation recommendations