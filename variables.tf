# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  description = "Region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "owner" {
  description = "Resource owners Active Directory user id."
  type        = string
  default     = "owner"
}

variable "costcenter" {
  description = "Costcenter associated with these resoures."
  type        = string
  default     = "cc"
}

variable "app_name" {
  description = "Application name abbreviation. Cannot be more than 5 characters long and no less than 2 and must also be lower case."
  type        = string
  default     = "app"

  validation {
    condition     = length(var.app_name) >= 2 && length(var.app_name) <= 5 && var.app_name == lower(var.app_name)
    error_message = "Valid name must be at least 2 characters and no more than 5. Name must be lower case."
  }
}

variable "environment" {
  description = "Environment the resources are being provisioned for. Valid options are 'prod', 'uat', 'dev', 'qa' 'sandbox'."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["prod", "uat", "qa", "dev", "sandbox"], var.environment)
    error_message = "Must be a valid and environment. Acceptable types are prod, uat, qa, dev and sandbox."
  }
}

variable "vpc_id" {
  description = "ID of the VPC in which MSK will be attached."
  type        = string
  default     = "vpc-XXXXXXXX"
}

variable "msk_subnet_ids" {
  description = "List of subnet IDs to use for MSK private subnets."
  type        = list(string)
  default     = ["subnet-XXXXXXXX", "subnet-XXXXXXXX"]
}

variable "msk_security_group_ids" {
  description = "A list of security group IDs to assign to the MSK cluster."
  type        = list(string)
  default     = ["sg-XXXXXXXX"]
}

variable "encryption_at_rest_kms_key_arn" {
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest."
  type        = string
  default     = ""
}

variable "encryption_in_transit_client_broker" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT. Default value is TLS_PLAINTEXT."
  type        = string
  default     = "TLS"
}

variable "encryption_in_transit_in_cluster" {
  description = "Whether data communication among broker nodes is encrypted. Default value: true."
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "additional_tags" {
  description = "A mapping of additional tags to assign to all resources."
  type        = map(string)
  default     = {}
}
