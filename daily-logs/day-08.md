# Day 08 — Auto-Scaling Policy Design
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Full Day — Auto-Scaling Policy Specifications

### Service 1: Loan Application API

| Parameter | Value |
|---|---|
| Scaling Strategy | Target Tracking (CPU 60%) |
| Scale-Out Cooldown | 90 seconds (aggressive) |
| Scale-In Cooldown | 600 seconds (conservative) |
| Min Instances | 2 (HA requirement) |
| Max Instances | 20 |
| Instance Types | m5.large (on-demand base), m5a.large (spot burst) |
| Spot Mix | 0% (latency-sensitive, SLA-critical) |
| Compliance | Audit trail maintained during scale events |
| Predictive Scaling | Pre-warm +4 instances at 9 AM IST daily |

### Service 2: Credit Scoring Engine

| Parameter | Value |
|---|---|
| Scaling Strategy | Step Scaling + Scheduled |
| Scale-Out Cooldown | 120 seconds |
| Scale-In Cooldown | 900 seconds |
| Min Instances | 3 (RBI IT quorum requirement) |
| Max Instances | 15 |
| Instance Types | c5.xlarge (compute-optimised) |
| Spot Mix | 0% (RBI IT compliance constraint) |
| Compliance | Model versioning consistent across all replicas |
| Predictive Scaling | Pre-warm for month-end processing surges |

### Service 3: Document Processing Service

| Parameter | Value |
|---|---|
| Scaling Strategy | Queue-based (SQS-triggered) |
| Scale-Out Trigger | Queue depth > 100 messages |
| Scale-In Trigger | Queue depth < 10 messages for 10 minutes |
| Min Instances | 0 (scale to zero off-hours) |
| Max Instances | 50 |
| Instance Types | m5.large (on-demand: 4), m5a.large (spot: remainder) |
| Spot Mix | 70% (fault-tolerant, queue-based) |
| Compliance | PII data handling compliant at all scale levels |

### Service 4: Payment Gateway

| Parameter | Value |
|---|---|
| Scaling Strategy | Target Tracking (Request Count per Target) |
| Target RPS per Instance | 1,000 requests |
| Scale-Out Cooldown | 60 seconds (very aggressive) |
| Scale-In Cooldown | 1200 seconds (very conservative) |
| Min Instances | 3 (multi-AZ: 1 per AZ) |
| Max Instances | 12 |
| Instance Types | c5.large (on-demand only) |
| Spot Mix | 0% (PCI DSS compliance, availability requirement) |
| Compliance | PCI DSS zone isolation maintained during all scaling events |

### Service 5: Reporting & Analytics

| Parameter | Value |
|---|---|
| Scaling Strategy | Scheduled + Event-driven |
| Scheduled Scale-Up | 6 AM IST (before business hours) |
| Scheduled Scale-Down | 8 PM IST (after business hours) |
| Weekend Schedule | Scale to 0 (Saturday 10 PM — Monday 7 AM) |
| Min Instances | 0 (off-hours) |
| Max Instances | 10 |
| Instance Types | r5.large (on-demand: 2), r5a.large (spot: remainder) |
| Spot Mix | 60% |
| Compliance | Data access controls preserved across all instances |

### Service 6: Notification Service

| Parameter | Value |
|---|---|
| Scaling Strategy | Step Scaling (Queue Depth) |
| Step 1 | Queue > 500: add 2 instances |
| Step 2 | Queue > 2000: add 4 instances |
| Step 3 | Queue > 5000: add 6 instances |
| Scale-In | Queue < 100 for 15 minutes: remove 1 instance |
| Min Instances | 1 |
| Max Instances | 8 |
| Instance Types | t3.medium (on-demand: 1), t3a.medium (spot: remainder) |
| Spot Mix | 50% |
| Compliance | Message delivery guarantees maintained |

---

## Scheduled Scaling — Dev/Staging Environments

### Schedule Configuration
- **Scale Down:** 7:00 PM IST Monday–Friday, 10:00 PM IST Friday (weekend)
- **Scale Up:** 9:00 AM IST Monday–Friday
- **Weekend:** Zero instances Saturday–Sunday (except on-call emergency access)

### Savings Calculation

| Environment | Current Monthly Cost | Hours Saved | Savings % | Monthly Savings |
|---|---|---|---|---|
| Development (22 instances) | $25,000 | 14 hrs/day + 48 hrs weekend | 58% | $14,500 |
| Staging (18 instances) | $22,000 | 14 hrs/day + 48 hrs weekend | 58% | $12,760 |
| **Total** | **$47,000** | | | **$27,260** |

*Note: Savings partially overlap with right-sizing estimates — net additional: ~$13,000/month*

---

## Predictive Scaling Rules

| Event | Trigger | Pre-warm Action | Lead Time |
|---|---|---|---|
| Month-end processing | 28th of each month | +6 instances loan-origination-api | 2 hours before |
| Salary day disbursement | 1st and 15th | +4 instances payment-gateway | 1 hour before |
| Marketing campaign | Campaign calendar API | +8 instances loan-origination-api | 30 minutes before |
| Quarter-end reporting | Last day of quarter | +6 instances reporting service | 4 hours before |

---

## Key Learnings Today
1. Asymmetric cooldowns are critical — aggressive scale-out, conservative scale-in prevents oscillation
2. Dev/staging scheduled shutdown saves $13,000+/month — easiest high-impact quick win
3. Payment gateway and credit scoring cannot use spot — compliance overrides cost savings
4. Predictive scaling for salary days prevents reactive scaling lag causing latency spikes

---

## Tomorrow's Plan
- Design complete FinOps governance model
- Create RACI matrix for all FinOps activities
- Define review cadences and budget governance hierarchy