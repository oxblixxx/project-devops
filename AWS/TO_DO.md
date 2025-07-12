This is basically todo for new AWS accounts. 

After succesful login, ensure to configure MFA for the root user.

Search for IAM > Locate Security recommendations. Then click on it to configure MFA.

After succesful setup of MFA, tHen create an IAM for an ADMIN account. To the left corner, under `Access Management`, click on User Groups > Create Group > Under Attach policies, Grant Administrator Access. > Create User Group
Then click on Users > Create User > Enable provide user access to management console > `I want to create an IAM user` > Set password > Next 
Then Selet `Add user to group` > Highlight administrator group > Next.
Here are possible tags to add.
```json
{
  "IAMUserTags": {
    "CoreIdentificationTags": {
      "Owner": "EMAIL_FORMAT (e.g., alice.smith@company.com)",
      "Name": "HUMAN_READABLE_ID (e.g., prod-web-server-01)"
    },
    "OrganizationalTags": {
      "Department": ["security", "engineering", "finance", "devops"],
      "Team": "TEAM_NAME (e.g., cloud-infra)",
      "Role": ["cloud-admin", "developer", "sysadmin", "analyst"],
      "EmploymentType": ["full-time", "contractor", "intern", "service-account"]
    },
    "EnvironmentTags": {
      "EnvironmentAccess": ["prod", "dev", "staging", "all"],
      "Jurisdiction": ["EU", "US", "APAC"]
    },
    "FinancialTags": {
      "CostCenter": "ACCOUNTING_CODE (e.g., CC-67890)",
      "Project": ["migration-2024", "ai-poc"],
      "BudgetOwner": "EMAIL_FORMAT (e.g., team-lead@company.com)"
    },
    "SecurityComplianceTags": {
      "DataAccessLevel": ["read-only", "read-write", "admin", "deny"],
      "MFAEnforced": ["true", "false"],
      "Compliance": ["PCI", "HIPAA", "GDPR", "SOC2", "NONE"],
      "AccessExpiryDate": "ISO_DATE_FORMAT (e.g., 2025-12-31)",
      "PasswordRotation": ["30days", "90days", "never"]
    },
    "OperationalTags": {
      "CreationDate": "ISO_DATE_FORMAT (e.g., 2024-07-12)",
      "LastReviewDate": "ISO_DATE_FORMAT",
      "AutoExpire": ["true", "false"],
      "SessionTimeout": ["1h", "4h", "8h"],
      "PermissionBoundary": ["read-only-policy", "admin-boundary"]
    },
    "AdvancedTags": {
      "SSOProvider": ["Okta", "AzureAD", "Google"],
      "EmergencyAccess": ["breakglass", "none"],
      "OnCall": ["primary", "secondary", "none"]
    }
  },
  "ExampleUser": {
    "Owner": "alice.smith@company.com",
    "Department": "security",
    "Role": "cloud-admin",
    "EmploymentType": "full-time",
    "EnvironmentAccess": "prod",
    "CostCenter": "CC-67890",
    "CreationDate": "2024-07-12",
    "DataAccessLevel": "admin",
    "MFAEnforced": "true",
    "Compliance": "SOC2",
    "SSOProvider": "Okta"
  }
}
```

Then create user!

To look into, later!!!! ENFORCING MFA FOR NEWLY CREATED USERS.  [https://repost.aws/questions/QU3N82Ig6oSLOvcTBCB1_Jhg/how-to-enforce-enable-mfa-for-other-users](MFA)  

https://spot.io/resources/aws-cost-optimization/quick-guide-to-aws-budgets-tutorial-and-best-practices/

https://spot.io/resources/aws-cost-optimization/aws-cost-management/

To set up budgets, Navigate to Billing and cost management, then go to budgets > create budget. THe template version doesnt give granuality, so choose advanced, then cost budgets. So set budget name, budget scope, budgeting method. For aggregated costs, refer to this [docs](https://docs.aws.amazon.com/cost-management/latest/userguide/create-cost-budget.html), So TO CONFIGURE ALERTS, WE WILL BE USING CHATBOTS ALERTS, SO THE WAY IT WORKS IS THAT, IT NEEDS SNS TOPIC, SO WE LINK A MEDIUM TO AMAZON Q, WHICH I TESTED WITH SLACK. SO WE GIVE PERMISSIONS.
DRop down amazon q alerts, then right click on here, configure chat client, teams needs administrative privileges to be able to link. GEt started with slack by signing in to a workspace, create a workspace from slack app, then allow request permission to slack. after linking slack workspace, then go to SNS service, create a topic, select name, then expand access policy then choose advanced, copy this below content, but here is [AWS docs](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-sns-policy.html).
```json
{
  "Version": "2012-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "AWSBudgetsSNSPublishingPermissions",
      "Effect": "Allow",
      "Principal": {
        "Service": "budgets.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:123456789012:budget-alert",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "123456789012"
        },
        "ArnLike": {
          "aws:SourceArn": "arn:aws:budgets::123456789012:*"
        }
      }
    },
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:Publish",
        "SNS:RemovePermission",
        "SNS:SetTopicAttributes",
        "SNS:DeleteTopic",
        "SNS:ListSubscriptionsByTopic",
        "SNS:GetTopicAttributes",
        "SNS:AddPermission",
        "SNS:Subscribe"
      ],
      "Resource": "arn:aws:sns:us-east-1:123456789012:budget-alert",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": "123456789012"
        }
      }
    }
  ]
}
```
Modify the ACCOUNT ID ALONE, THEN CLICK ON CREATE NEW TOPIC, THEN GO TO AMAZON Q, CLICK ON CONFIGURE CHANNEL FOR THE CREATED CLIENTS, THEN MAKE IT PRIVATE, GO BACK TO SLACK AND LONG PRESS THE CHANNEL AND CLICK ON COPY, FETCH THE STRING THAT START FROM C AND PASTE IT, THAT THE SLACK ID, THEN FOR PERMISSION, CHANNEL ROLE OR USER LEVEL WORKS, THEN SELECT SNS TOPIC REGION, AND SELECT THE CREATED TOPIC, THEN CLICK ON CONFIGURE. So how it works it configured, sns topic created, then  amazon q client is configured, then while setting the amazon q, the created topic is linked, and then the arn of the topic is added to the budgets in the SNS part. Then send a test message from Amazon Q to confirm that it works. 


