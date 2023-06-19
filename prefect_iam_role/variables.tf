variable "aws_region" {
  description = "AWS Region to be used that was defined in AWS CLI configuration"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Name of your project/product/application"
  type        = string
}


variable "dask_required" {
  description = "Whether the job needs to use Dask"
  type        = bool
  default     = false
}

variable "job_execution_iam_policies" {
  description = "ARNs of the policies required by the job"
  type        = list(string)
}

variable "additional_assume_role_policy_statements" {
  description = "Additional assume role policy statements"
  type        = string
  nullable    = true
  default     = null
}

variable "execution_eks_clusters" {
  description = "The name of clusters where job will be executed. (bigdata-eks-staging/bigdata-eks-production)"
  type        = list(string)

  validation {
    condition     = alltrue([for i in var.execution_eks_clusters : contains(["bigdata-eks-staging", "bigdata-eks-production"], i)])
    error_message = "Values must be from [bigdata-eks-staging bigdata-eks-production]"
  }
}

variable "dev_role_arn" {
  description = "ARN of the role that will be used by developers to assume the job execution role"
  type        = string
}
