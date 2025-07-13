variable "access_key" {
  description = "AWS access_key to deploy resources"
  type        = string
}

variable "secret_key" {
  description = "AWS secret_key to deploy resources"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}


##########################################
### P.MUSTAPHA USER VARIABLE
##########################################
variable "p_mustapha" {
  description = "account username"
  type = string
  default = "p_mustapha"
}

variable "p_mustapha_kb" {
  description = "keybase account name"
  type    = string
  default = "oxblixxx"
}

variable "p_mustapha_create_iam_user_login_profile" {
  description = "enable or disable console access"
  type    = bool
  default = false
}

variable "p_mustapha_create_iam_access_key" {
  description = "enable or disable api access"
  type    = bool
  default = true
}
