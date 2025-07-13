variable "access_key" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "secret_key" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
