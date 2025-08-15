# Configuring Amazon CloudFront with a Private Amazon S3 Bucket (Manual Setup via AWS Console)

## Overview
This guide provides step-by-step instructions for setting up an Amazon CloudFront distribution with a private Amazon S3 bucket, ensuring secure content delivery while restricting direct access to the S3 bucket.

## Prerequisites
- AWS account with permissions to:
  - Create and configure S3 buckets
  - Create CloudFront distributions
  - Manage IAM policies and users
- Basic understanding of:
  - AWS S3 bucket configurations
  - CloudFront CDN concepts
  - IAM permission management

## Step 1: Create an S3 Bucket
1. Navigate to the [Amazon S3 console](https://console.aws.amazon.com/s3)
2. Click **Create bucket**
3. Configure bucket settings:
   - **General configuration**:
     - Bucket name: Enter a globally unique DNS-compliant name
   - **Object Ownership**:
     - Select "Bucket owner enforced" (recommended to disable ACLs)
   - **Block Public Access settings**:
     - Enable "Block all public access"
   - **Bucket Versioning**:
     - Enable versioning (recommended for data protection)
   - **Default encryption**:
     - Enable and select either:
       - SSE-S3 (Amazon S3-managed keys)
       - SSE-KMS (AWS KMS-managed keys)
   - **Advanced settings**:
     - Enable Object Lock if WORM (Write Once Read Many) compliance is required
4. Click **Create bucket**

## Step 2: Create a CloudFront Distribution
1. Navigate to the [CloudFront console](https://console.aws.amazon.com/cloudfront)
2. Click **Create distribution**
3. Configure origin settings:
   - **Origin domain**: Select your S3 bucket from the dropdown
   - **Origin path**: Optional subdirectory path
   - **S3 bucket access**:
     - Select "Yes use OAI (Origin Access Identity)"
     - Select "Create new OAI"
     - Enable "Yes, update the bucket policy"
4. Configure default cache behavior settings:
   - Leave most settings as default unless specific requirements exist
5. (Optional) Enable AWS WAF:
   - Select "Enable security protections"
6. Click **Create distribution**

> **Note**: Distribution deployment typically takes 10-30 minutes to complete.

## Step 3: Configure IAM Permissions (Optional)
For applications requiring programmatic access:

1. Navigate to [IAM console](https://console.aws.amazon.com/iam)
2. Create a new IAM user
3. Attach a custom policy with necessary permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
