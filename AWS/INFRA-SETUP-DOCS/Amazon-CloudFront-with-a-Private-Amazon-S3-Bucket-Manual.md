# Configuring Amazon CloudFront with a Private Amazon S3 Bucket (Manual Setup via AWS Console)

This documentation outlines the steps to configure an Amazon CloudFront distribution with a private Amazon S3 bucket, ensuring secure content delivery while maintaining restricted direct access to the S3 bucket.

## Prerequisites
- An AWS account with appropriate permissions to create S3 buckets, CloudFront distributions, and IAM policies.
- Basic understanding of AWS S3, CloudFront, and IAM.

## Step 1: Create an S3 Bucket
1. Log in to the AWS Management Console and navigate to Amazon S3.
2. Click **Create bucket**.
3. Configure bucket settings:
   - **Bucket name**: Enter a globally unique name.
   - **Disable ACLs (Recommended)**
   - **Block all public access**
   - **Enable versioning**
   - **Set default encryption** 
   - **Enable Object Lock **
4. Click **Create bucket**.

## Step 2: Create a CloudFront Distribution
1. Navigate to the Amazon CloudFront service in the AWS Console.
2. Click **Create distribution**.
3. Configure distribution settings:
   - **Distribution type**: Select "Web" for standard content delivery.
   - **Origin settings**:
     - **Origin domain**: Select the S3 bucket created earlier.
     - **Origin path (Optional)**: Specify a subdirectory if needed.
     - **S3 bucket access**:
       - Enable "Allow private S3 bucket access to CloudFront - Recommended" to allow CloudFront to update your S3 bucket policy to allow CloudFront to access your S3 bucket.
   - **Default origin settings**: Leave as default unless specific caching rules are required.
   - **Default cache behavior settings**: Leave as default unless specific caching rules are required.
   - **Web Application Firewall (WAF)**: Enable AWS WAF for additional security (optional but recommended).
4. Click **Create distribution**.

> **Note**: CloudFront deployment may take 10-30 minutes to complete.

## Step 3: Configure IAM Permissions (Optional for Programmatic Access)
If applications require programmatic access to CloudFront or S3:
1. Navigate to AWS IAM.
2. Create an IAM user with secure credentials.
3. Attach a custom policy with the necessary permissions (e.g., `s3:PutObject`, `s3:DeleteObject` if modifying objects via CloudFront).

Example policy (adjust as needed):
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
```

Once the distribution status changes to Deployed, access objects using the CloudFront domain name (e.g., https://dxxxxxxxxxxxx.cloudfront.net/object-key
