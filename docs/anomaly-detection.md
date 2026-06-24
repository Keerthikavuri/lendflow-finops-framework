# Cost Anomaly Detection & Alerting Framework — LendFlow Technologies
**Prepared by:** Keerthi Kavuri, FinOps Engineer  
**Date:** June 2026

---

## Overview

This document defines the cost anomaly detection and alerting framework for LendFlow Technologies. Currently, all 10 cost anomalies over the past 6 months were detected at monthly bill review — an average detection delay of 18 days. This framework reduces mean time to detection (MTTD) to under 4 hours through multi-layer automated detection.

**Current MTTD:** 18 days (monthly bill review)  
**Target MTTD:** <4 hours (automated detection)  
**Financial Impact of 18-day delay:** $38,000+ in avoidable spend on past anomalies

---

## Anomaly Event Analysis (6-Month Historical)

| # | Service | Anomaly Type | Expected | Actual | Variance | Financial Impact |
|---|---|---|---|---|---|---|
| 1 | EC2 | Runaway ASG scaling | $8,200 | $19,400 | +137% | $11,200 |
| 2 | RDS | Snapshot accumulation | $1,200 | $3,800 | +217% | $2,600 |
| 3 | Data Transfer | Cross-AZ spike | $4,400 | $9,200 | +109% | $4,800 |
| 4 | S3 | Storage class drift | $2,800 | $5,600 | +100% | $2,800 |
| 5 | Lambda | Infinite retry loop | $600 | $8,900 | +1383% | $8,300 |
| 6 | NAT Gateway | Dev env left running | $1,800 | $4,200 | +133% | $2,400 |
| 7 | EC2 | GPU fleet launched | $3,200 | $28,400 | +788% | $25,200 |
| 8 | ElastiCache | Aggressive scaling | $1,100 | $3,300 | +200% | $2,200 |
| 9 | CloudWatch | Log explosion | $800 | $4,200 | +425% | $3,400 |
| 10 | EBS | Volume provisioning | $2,200 | $6,800 | +209% | $4,600 |
| **Total** | | | | | | **$67,500** |

### Pattern Analysis

| Pattern | Occurrences | Total Impact | Prevention |
|---|---|---|---|
| IaC configuration errors | 3 | $36,400 | Infracost in CI/CD + Terraform validation |
| Missing lifecycle policies | 2 | $5,400 | Automated Config Rules |
| Runaway auto-scaling | 2 | $13,600 | SCP max instance count limits |
| Debug logging left enabled | 1 | $3,400 | CloudWatch log retention policies |
| Dev environment not shutdown | 1 | $2,400 | Scheduled scaling automation |
| Application bug (retry loop) | 1 | $8,300 | Lambda concurrency limits |

---

## Multi-Layer Detection Architecture

### Layer 1 — Static Threshold Alerts

**Implementation:** AWS Budgets + CloudWatch Alarms  
**Detection Speed:** Within 1 hour of threshold breach

| Alert | Threshold | Severity | Action |
|---|---|---|---|
| Daily spend spike | >120% of 30-day average | P3 | Slack #finops-weekly |
| Daily spend spike | >150% of 30-day average | P2 | Slack #finops-alerts + Email |
| Daily spend spike | >200% of 30-day average | P1 | PagerDuty + SMS |
| New unbudgeted service | Any spend on service not in budget | P2 | Slack #finops-alerts |
| Monthly budget | >80% consumed | P3 | Slack notification |
| Monthly budget | >100% consumed | P1 | PagerDuty escalation |

**Limitation:** Prone to false positives during legitimate scaling events (campaign launches, month-end processing).

### Layer 2 — Statistical Detection (Moving Average)

**Implementation:** Custom Lambda function + CloudWatch scheduled rule  
**Detection Speed:** Within 4 hours  
**Schedule:** Runs every 4 hours

```python
def detect_statistical_anomaly(service, daily_costs, window=14):
    """
    Detect anomalies using rolling mean + 2 standard deviations
    """
    rolling_mean = sum(daily_costs[-window:]) / window
    rolling_std = statistics.stdev(daily_costs[-window:])
    
    threshold_upper = rolling_mean + (2 * rolling_std)
    threshold_lower = rolling_mean - (2 * rolling_std)
    
    today_cost = daily_costs[-1]
    
    if today_cost > threshold_upper:
        severity = 'P1' if today_cost > (rolling_mean * 2) else 'P2'
        trigger_alert(service, today_cost, rolling_mean, severity)
    
    return {
        'service': service,
        'today': today_cost,
        'mean': rolling_mean,
        'upper_threshold': threshold_upper,
        'anomaly_detected': today_cost > threshold_upper
    }
```

**Advantage:** Adapts to growing baseline — reduces false positives vs static thresholds.  
**Limitation:** Slow to detect gradual cost creep (costs increasing 5% per week).

### Layer 3 — ML-Based Detection (AWS Cost Anomaly Detection)

**Implementation:** AWS Cost Anomaly Detection service  
**Detection Speed:** Within 4 hours  
**Configuration:**

```json
{
  "AnomalyMonitors": [
    {
      "MonitorName": "lendflow-service-monitor",
      "MonitorType": "DIMENSIONAL",
      "MonitorDimension": "SERVICE"
    },
    {
      "MonitorName": "lendflow-linked-account-monitor", 
      "MonitorType": "DIMENSIONAL",
      "MonitorDimension": "LINKED_ACCOUNT"
    }
  ],
  "AnomalySubscriptions": [
    {
      "SubscriptionName": "lendflow-finops-alerts",
      "MonitorArnList": ["arn:aws:ce::123456789:anomalymonitor/xxx"],
      "Subscribers": [
        {
          "Address": "finops-alerts@lendflow.com",
          "Type": "EMAIL"
        },
        {
          "Address": "arn:aws:sns:us-east-1:123456789:finops-critical",
          "Type": "SNS"
        }
      ],
      "Threshold": 100,
      "Frequency": "IMMEDIATE"
    }
  ]
}
```

**Advantage:** ML-trained on historical patterns — lowest false positive rate.

### Layer 4 — Business Event Correlation

**Implementation:** Integration with deployment calendar + marketing schedule  
**Purpose:** Filter legitimate cost increases from genuine anomalies

Business Event Allowlist:

1st of month (salary day): Allow 150% baseline for loan-api, payment-gateway
15th of month (salary day): Allow 150% baseline for loan-api, payment-gateway
28th-31st of month: Allow 130% baseline for reporting, analytics
Marketing campaign flag: Allow 200% baseline for loan-api during campaign window
Deployment event: Suppress alerts for 2 hours post-deployment (scaling warmup)

---

## Alert Severity Classification

| Severity | Trigger Condition | Response SLA | Notification Channel | Escalation Path |
|---|---|---|---|---|
| P1 Critical | Daily spend >200% baseline OR projected monthly >150% budget | 30 minutes | PagerDuty + SMS + Slack #finops-critical | FinOps Lead → CTO → CFO |
| P2 High | Daily spend >150% baseline OR new unbudgeted service | 4 hours | Slack #finops-alerts + Email | FinOps Lead → Engineering Manager |
| P3 Medium | Weekly spend >120% forecast OR tag compliance <90% | 24 hours | Slack #finops-weekly + Dashboard | FinOps Lead in weekly review |
| P4 Low | Minor drift 5–20% above baseline OR underutilised resource | Next review | Dashboard + Weekly report | Added to optimisation backlog |

---

## Anomaly Investigation Runbook

### Step 1: Triage (Within Response SLA)

Open AWS Cost Explorer → filter by date of anomaly
Identify affected service from anomaly alert details
Check deployment calendar — was there a release in last 24 hours?
Check CloudTrail — any new resource creation in last 24 hours?
Check Auto Scaling activity logs — any unexpected scale-out events?


### Step 2: Root Cause Identification

Common Root Causes Checklist:

[ ] Auto-scaling misconfiguration (check ASG max_capacity value)

[ ] IaC variable error (check recent Terraform applies in CI/CD)

[ ] Debug logging left enabled (check CloudWatch log group sizes)

[ ] Lifecycle policy misconfigured (check S3 bucket lifecycle rules)

[ ] Dev environment not shut down (check ASG scheduled actions)

[ ] New cross-AZ service deployment (check data transfer logs)

[ ] Lambda concurrency/retry misconfiguration (check Lambda metrics)

[ ] Spot instance fleet over-provisioned (check Spot Fleet requests)

### Step 3: Containment

Immediate Actions by Root Cause:

Runaway ASG: aws autoscaling update-auto-scaling-group --max-size [correct-value]
GPU instance error: Terminate instances, apply SCP to prevent recurrence
Lambda retry loop: Set reserved concurrency to 0 to stop immediately
Debug logging: Delete/expire log groups, set retention policy
Dev env running: Execute scale-down scheduled action immediately


### Step 4: Resolution & Prevention

Short-term: Fix root cause configuration

Long-term: Add guardrail to prevent recurrence

Add SCP rule
Add Config Rule
Add Terraform validation
Add Infracost threshold check

Documentation:

Update this runbook with new root cause pattern
Complete RCA document within 24 hours of resolution
Present findings in next weekly tactical review


### RCA Document Template

COST ANOMALY ROOT CAUSE ANALYSIS
Anomaly ID: ANO-YYYY-MM-DD-XXX

Detection Method: [Layer 1/2/3/4]

Detection Time: [timestamp]

Resolution Time: [timestamp]

MTTD: [X hours]

MTTR: [X hours]

Total Financial Impact: $[X]
Timeline:

[timestamp]: Anomaly began
[timestamp]: Alert fired
[timestamp]: Investigation started
[timestamp]: Root cause identified
[timestamp]: Containment action taken
[timestamp]: Resolution confirmed

Root Cause: [description]

Contributing Factors: [list]

Resolution: [description]

Prevention: [guardrail added]

Lessons Learned: [description]

---

## Alerting Architecture
Cost Data Sources

│

▼

┌─────────────────────────────────────────┐

│         Detection Layer                  │

│  L1: CloudWatch Alarms (static)          │

│  L2: Lambda statistical detection        │

│  L3: AWS Cost Anomaly Detection (ML)     │

│  L4: Business event correlation filter   │

└─────────────────┬───────────────────────┘

│

▼

SNS Topic: finops-alerts

│

┌─────────┴──────────┐

▼                    ▼

P1/P2 Alerts          P3/P4 Alerts

PagerDuty + SMS       Slack + Dashboard

Slack #finops-critical Slack #finops-weekly

│

▼

On-call FinOps Lead

Investigation → Runbook

Resolution → RCA

---

## Detection Performance Targets

| Metric | Current | 30-Day Target | 90-Day Target |
|---|---|---|---|
| Mean Time to Detect (MTTD) | 18 days | 4 hours | 1 hour |
| False Positive Rate | N/A | <10% | <5% |
| Alert Coverage | 0% automated | 80% automated | 95% automated |
| P1 Response Rate (within SLA) | 0% | 90% | 99% |

---

*Prepared by Keerthi Kavuri | FinOps Engineer | June 2026*