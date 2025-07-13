##########################################
### https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest
### https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-user?tab=inputs
##########################################

module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.59.0"
  # insert the 1 required variable here
  name = infrastructure
  create_group = true
  custom_group_policies = [

  ]
  enable_mfa_enforcement = true
  group_users = [
    s
  ]

  tags = {

  }


}

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = "infrastructure-user"
  force_destroy = true
  create_iam_access_key = true
  create_iam_user_login_profile = false 
  create_user = true
  pgp_key = "oxblixxx:infrastructure"

  password_reset_required = false
}


/* 
Hello wor
 */

 ##########################################
 ### SECTION_NAME
 ##########################################
 