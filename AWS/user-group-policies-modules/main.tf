##########################################
### https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-group-with-policies?tab=inputs
### https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-user?tab=inputs
### CREATE GROUP WITH POLICY AND ATTACH USER
### FOR NEWLY CREATED GROUPS! A DEPEND ON IS ATTATCHED!TO CREATE THE USE FIRST
##########################################
module "iam_iam-group-with-policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"    
  version = "5.59.0"
  name = "infrastructure"
  create_group = true
  
  custom_group_policies = [
    {
      name   = "infrastructure-full-access"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ec2:AllocateAddress",
              "ec2:AssociateIamInstanceProfile",
              "ec2:AssociateRouteTable",
              "ec2:AttachInternetGateway",
              "ec2:AttachVolume",
              "ec2:AuthorizeSecurityGroupEgress",
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:CreateInternetGateway",
              "ec2:CreateNatGateway",
              "ec2:CreateNetworkAclEntry",
              "ec2:CreateRoute",
              "ec2:CreateRouteTable",
              "ec2:CreateSecurityGroup",
              "ec2:CreateSubnet",
              "ec2:CreateTags",
              "ec2:CreateVolume",
              "ec2:CreateVpc",
              "ec2:DeleteInternetGateway",
              "ec2:DeleteNatGateway",
              "ec2:DeleteNetworkAclEntry",
              "ec2:DeleteRoute",
              "ec2:DeleteRouteTable",
              "ec2:DeleteSecurityGroup",
              "ec2:DeleteSubnet",
              "ec2:DeleteVpc",
              "ec2:DescribeInstanceAttribute",
              "ec2:DescribeInstanceStatus",
              "ec2:DescribeInstanceTypes",
              "ec2:DescribeInstances",
              "ec2:DescribeInternetGateways",
              "ec2:DescribeRouteTables",
              "ec2:DescribeSecurityGroupsForVpc",
              "ec2:DescribeSubnets",
              "ec2:DescribeVpcs",
              "ec2:DetachInternetGateway",
              "ec2:DetachVolume",
              "ec2:DisassociateAddress",
              "ec2:DisassociateRouteTable",
              "ec2:GetSecurityGroupsForVpc",
              "ec2:ModifyInstanceAttribute",
              "ec2:ModifyVpcAttribute",
              "ec2:ReleaseAddress",
              "ec2:ReplaceRoute",
              "ec2:RevokeSecurityGroupEgress",
              "ec2:RevokeSecurityGroupIngress",
              "ec2:RunInstances",
              "ec2:StartInstances",
              "ec2:StopInstances",
              "ec2:TerminateInstances",
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:CreateListener",
              "elasticloadbalancing:CreateLoadBalancer",
              "elasticloadbalancing:CreateTargetGroup",
              "elasticloadbalancing:DeleteListener",
              "elasticloadbalancing:DeleteLoadBalancer",
              "elasticloadbalancing:DeleteTargetGroup",
              "elasticloadbalancing:DescribeListenerAttributes",
              "elasticloadbalancing:DescribeListeners",
              "elasticloadbalancing:DescribeLoadBalancerAttributes",
              "elasticloadbalancing:DescribeLoadBalancers",
              "elasticloadbalancing:DescribeTags",
              "elasticloadbalancing:DescribeTargetGroupAttributes",
              "elasticloadbalancing:DescribeTargetGroups",
              "elasticloadbalancing:DescribeTargetHealth",
              "elasticloadbalancing:DeregisterTargets",
              "elasticloadbalancing:ModifyListener",
              "elasticloadbalancing:ModifyLoadBalancerAttributes",
              "elasticloadbalancing:ModifyTargetGroup",
              "elasticloadbalancing:ModifyTargetGroupAttributes",
              "elasticloadbalancing:RegisterTargets",
              "elasticloadbalancing:RemoveTags",
              "iam:AddRoleToInstanceProfile",
              "iam:AttachRolePolicy",
              "iam:CreateInstanceProfile",
              "iam:CreateRole",
              "iam:CreateServiceLinkedRole",
              "iam:DeleteInstanceProfile",
              "iam:DeleteRole",
              "iam:DeleteRolePolicy",
              "iam:DetachRolePolicy",
              "iam:GetInstanceProfile",
              "iam:GetRole",
              "iam:GetRolePolicy",
              "iam:ListAttachedRolePolicies",
              "iam:ListInstanceProfilesForRole",
              "iam:ListRolePolicies",
              "iam:PassRole",
              "iam:PutRolePolicy",
              "iam:RemoveRoleFromInstanceProfile",
              "iam:UpdateRole",
              "iam:UpdateRoleDescription",
              "kms:CreateKey",
              "kms:DescribeKey",
              "kms:List*",
              "s3:CreateBucket",
              "s3:DeleteBucket",
              "s3:Get*",
              "s3:List*",
              "s3:Put*",
              "secretsmanager:CreateSecret",
              "secretsmanager:GetSecretValue"
            ]
            Resource = "*"
            Condition = {
              StringEquals = {
                "aws:RequestedRegion" = "us-east-1"
              }
            }
          }
        ]
      })
    }
  ]
  
  enable_mfa_enforcement = true
  group_users = [var.p_mustapha]
  depends_on = [module.p_mustapha_iam]
  tags = {
    "Terraform": "True",
    "CreationDate": "2025-07-13",
  }
}

##########################################
### https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
### CREATE USER IAM USER FOR PELUMI  IN INFRASTRUCTURE GROUP
##########################################
module "p_mustapha_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  name          = var.p_mustapha
  force_destroy = false
  create_iam_access_key = var.p_mustapha_create_iam_access_key 
  create_iam_user_login_profile = var.p_mustapha_create_iam_user_login_profile
  create_user = true
  pgp_key = "keybase:${var.p_mustapha_kb}"
  password_reset_required = false
  password_length  = 15
  tags = {
    "Group": "infrastructure",
    "Terraform": "true",
    "EmploymentType": "contractor",
    "EnvironmentAccess": "dev"
    "Jurisdiction": "US"
  }
}

