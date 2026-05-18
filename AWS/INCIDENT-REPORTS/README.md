# 🔍 CloudTrail Incident Investigation Project

This project documents a real-world security incident response involving suspected compromise of an AWS IAM user. The investigation was carried out using AWS CloudTrail and related AWS security tools to identify unauthorized activity, analyze API calls, and determine the scope of the incident.

The objective of this work was to investigate, contain, and remediate a potential AWS account compromise using native AWS security and logging services, while maintaining service continuity and improving monitoring controls to prevent recurrence.


## 🛠 AWS Services Used
### 🔐 Security & Identity
- AWS IAM
   - User access management
   - Policy assignment and revocation
   - Role-based access control for remediation
### 📊 Logging & Monitoring
- AWS CloudTrail
   - API activity tracking
   - Event history analysis
   - Lookup queries for IAM user activity
   - Source IP and region inspection
### 💰 Cost Monitoring
- AWS Budgets
   - Set spending threshold alerts (3-month window)
   - Detect unusual cost spikes potentially caused by unauthorized usage


## SCRIPT EXECUTION
1. Make the script executable
2. Then run the script this way `./script.sh <suspected_IAM_USERNAME> 2026-05-15T00:00:00Z 2026-05-18T00:00:00Z`
