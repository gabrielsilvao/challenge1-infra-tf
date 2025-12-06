variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type for the repository. Must be one of: AES256 or KMS"
  type        = string
  default     = "AES256"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption (only used when encryption_type is KMS)"
  type        = string
  default     = null
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "enable_lifecycle_policy" {
  description = "Enable lifecycle policy for image retention"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Maximum number of tagged images to keep"
  type        = number
  default     = 30
}

variable "untagged_image_expiry_days" {
  description = "Number of days to keep untagged images"
  type        = number
  default     = 14
}

variable "repository_policy" {
  description = "JSON formatted repository policy for cross-account access"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}
