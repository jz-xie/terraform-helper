variable "bucket_name" {
  description = "The S3 bucket name"
  type        = string
}

variable "required_tags" {
  description = "Required tags for resource in S3"
  type = object({
    Classification = string
    Impact         = string
    DataType       = string
  })

  validation {
    condition     = contains(["Public", "External", "Internal", "Confidential"], var.required_tags["Classification"])
    error_message = "Classification must be one of [\"Public\", \"External\", \"Internal\", \"Confidential\"] "
  }

  validation {
    condition     = contains(["Low", "Medium", "High"], var.required_tags["Impact"])
    error_message = "Impact must be one of [\"Low\", \"Medium\", \"High\"]"
  }

  validation {
    condition     = contains(["PII", "PCI", "IP", "COD", "Uncategorized"], var.required_tags["DataType"])
    error_message = "DataType must be one of [\"PII\", \"PCI\", \"IP\", \"COD\", \"Uncategorized\"]"
  }
}

variable "additional_tags" {
  description = "Addtional tags for resource in S3"
  type        = map(string)
  default     = null
  nullable    = true
}


variable "bucket_policy" {
  description = "Bucket policy"
  default     = null
  nullable    = true
}
variable "block_public_acls" {
  default = true
}
variable "block_public_policy" {
  default = true
}
variable "ignore_public_acls" {
  default = true
}
variable "restrict_public_buckets" {
  default = true
}
