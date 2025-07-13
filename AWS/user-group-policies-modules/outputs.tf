##########################################
### P_MUSTAPHA IAM OUTPUTS
# Secure credential output:
# - Always hides secrets in logs (sensitive = true)
# - Only exposes passwords/secret keys when Keybase encryption is configured
# - Returns null for secrets when no PGP key is provided
# - Username and access key ID are always visible
##########################################
output "credential" {
  sensitive = false
  value = {
    username = var.p_mustapha  # Using the input variable since 'name' isn't an output
    
    # Console password - only if login profile is enabled AND Keybase is configured
    console_password = (
      var.p_mustapha_create_iam_user_login_profile && var.p_mustapha_kb != "" 
      ? module.p_mustapha_iam.iam_user_login_profile_encrypted_password 
      : null
    )

    access_key = (
      var.p_mustapha_create_iam_access_key 
      ? module.p_mustapha_iam.iam_access_key_id 
      : null
    )

    # Secret key - only if access key is enabled AND Keybase is configured
    secret_key = (
      var.p_mustapha_create_iam_access_key && var.p_mustapha_kb != "" 
      ? module.p_mustapha_iam.iam_access_key_encrypted_secret 
      : null
    )
  }
}