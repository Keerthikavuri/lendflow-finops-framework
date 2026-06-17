# Day 03 — Deep-Dive Cost Analysis: Storage & Data Transfer
**Date:** 2026-06-17  
**Project:** LendFlow Technologies — Infrastructure Cost Optimisation & FinOps Framework

---

## Morning Session — Storage Inventory Analysis

### S3 Bucket Analysis

| Bucket Name | Size (TB) | Storage Class | Last Accessed | Monthly Cost | Recommendation | Savings |
|---|---|---|---|---|---|---|
| lendflow-loan-docs | 12.4 | Standard | 95+ days ago | $285 | Transition to IA | $142 |
| lendflow-audit-logs | 8.2 | Standard | Active | $189 | Keep (SOC 2) | $0 |
| lendflow-ml-training | 6.8 | Standard | 120+ days ago | $156 | Transition to Glacier | $125 |
| lendflow-backups | 22.1 | Standard | 180+ days ago | $508 | Glacier Deep Archive | $432 |
| lendflow-static-assets | 1.2 | Standard | Daily | $28 | Add CDN caching | $20 |
| lendflow-dev-dumps | 4.5 | Standard | 90+ days ago | $103 | Delete/Glacier | $93 |
| lendflow-reports | 3.1 | Standard | 60+ days ago | $71 | Transition to IA | $35 |
| lendflow-compliance | 5.6 | Standard | Active | $129 | Keep (PCI DSS) | $0 |

**Total S3 optimisation opportunity: ~$4,000–$5,000/month**

### EBS Volume Analysis

| Volume ID | Size | Type | Attached | Utilisation | Monthly Cost | Action | Savings |
|---|---|---|---|---|---|---|---|
| vol-001 | 1TB | gp2 | No | 0% | $80 | Delete immediately | $80 |
| vol-002 | 1TB | gp2 | No | 0% | $80 | Delete immediately | $80 |
| vol-003 | 500GB | gp2 | Yes | 18% | $40 | Rightsize to 100GB | $32 |
| vol-004 | 1TB | gp2 | No | 0% | $80 | Delete immediately | $80 |
| vol-005 | 2TB | gp3 | Yes | 22% | $128 | Rightsize to 500GB | $96 |
| vol-006 | 500GB | gp2 | No | 0% | $40 | Delete immediately | $40 |

**200+ unattached EBS volumes identified — total waste: ~$1,800/month**

### Storage Lifecycle Policy Design