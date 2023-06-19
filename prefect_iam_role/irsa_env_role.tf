resource "aws_iam_policy" "assume_execution_role_policy" {
  name        = "assume_role_${local.job_execution_role_name}_policy"
  path        = "/"
  description = "Policy to allow assume role: ${local.job_execution_role_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.job_execution_role_name}"]
      },
    ]
  })
}

module "bigdata_eks_staging" {
  source = "./irsa"
  count  = contains(var.execution_eks_clusters, local.eks_clusters[0]) ? 1 : 0

  eks_cluster_id        = data.aws_eks_cluster.this[local.eks_clusters[0]].id
  eks_oidc_provider_arn = data.aws_iam_openid_connect_provider.this[local.eks_clusters[0]].arn

  create_kubernetes_namespace = false
  kubernetes_namespace        = "prefect"
  kubernetes_service_account  = var.project

  irsa_iam_role_name = "${var.project}-staging"
  irsa_iam_policies  = [aws_iam_policy.assume_execution_role_policy.arn, data.aws_iam_policy.prefect_storage_staging_access.arn]

  providers = {
    kubernetes = kubernetes.bigdata-eks-staging
  }
}


module "bigdata_eks_production" {
  source = "./irsa"
  count  = contains(var.execution_eks_clusters, local.eks_clusters[1]) ? 1 : 0

  eks_cluster_id        = data.aws_eks_cluster.this[local.eks_clusters[1]].id
  eks_oidc_provider_arn = data.aws_iam_openid_connect_provider.this[local.eks_clusters[1]].arn

  create_kubernetes_namespace = false
  kubernetes_namespace        = "prefect"
  kubernetes_service_account  = var.project

  irsa_iam_role_name = "${var.project}-production"
  irsa_iam_policies  = [aws_iam_policy.assume_execution_role_policy.arn, data.aws_iam_policy.prefect_storage_production_access.arn]

  providers = {
    kubernetes = kubernetes.bigdata-eks-production
  }
}
