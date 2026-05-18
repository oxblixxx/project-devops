# Suspected IAM User Compromise and Response
---
# Incident Summary

AWS raised a security alert regarding a potentially affected or compromised resource. An investigation was conducted using `AWS CloudTrail` to determine the scope, identify the affected IAM user, and mitigate any security risks.

## Timeline & Investigation
Received and reviewed AWS Support report indicating suspicious activity. Identified the suspected compromised IAM user based on the report. Reviewed the IAM user’s permissions to understand access level and exposed resources.
- Queried AWS CloudTrail Event History, filtering by the IAM username.
- Analyzed events within the reported timeframe provided by AWS.
- Detected suspicious AWS API call activity (AwsApiCall) originating from unrecognized regions/zones.

## Findings
The IAM user exhibited activity from unrecognized geographic regions/zones.
Potential unauthorized or abnormal access patterns were observed in CloudTrail logs.
The user had insufficient privileges that could allow resource-level impact.

## Actions Taken (Containment & Remediation)
- Created a new IAM user and replicated the original policy attached to the affected user.
- Provisioned the new credentials to the development team.
- Verified system functionality and confirmed services operated normally using the new IAM user.
- Disabled and revoked the compromised IAM user to prevent further risk exposure.
- Implemented AWS Budgets monitoring over a 3-month period to detect abnormal or unexpected cost/resource usage.

## Outcome
- Compromised IAM user was successfully deactivated.
- No further suspicious activity detected after remediation.
- Operational continuity was maintained with minimal disruption.
- Monitoring and cost alerting were put in place to improve early detection of future anomalies.



## COMMANDS USED TO QUERY
Commands used can be found in `script.sh`
