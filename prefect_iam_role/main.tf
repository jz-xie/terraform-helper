terraform {
  required_providers {

    kubernetes = {
      version = ">=2.16.0"
    }

    aws = {
      version = ">=4.5.0"
    }
  }
}

locals {
  eks_clusters            = ["bigdata-eks-staging", "bigdata-eks-production"]
  job_execution_role_name = "${var.project}-job-execution"
  # job_roles               = [for role in [module.bigdata_eks_staging, module.bigdata_eks_production] : role if role != null]
  job_roles = [
    # module.bigdata_eks_staging != null ? module.bigdata_eks_staging[0].irsa_iam_role_arn : "",
    # module.bigdata_eks_production != null ? module.bigdata_eks_production[0].irsa_iam_role_arn : "",
  ]
}
