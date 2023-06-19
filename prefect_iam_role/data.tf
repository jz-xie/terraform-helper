data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  for_each = toset(local.eks_clusters)
  name     = each.key
}

data "aws_eks_cluster_auth" "this" {
  for_each = toset(local.eks_clusters)
  name     = each.key
}

data "aws_iam_openid_connect_provider" "this" {
  for_each = toset(local.eks_clusters)
  url      = data.aws_eks_cluster.this[each.key].identity[0].oidc[0].issuer
}


data "aws_iam_policy" "prefect_storage_staging_access" {
  name = "bigdata-prefect-storage-staging-access"
}

data "aws_iam_policy" "prefect_storage_production_access" {
  name = "bigdata-prefect-storage-production-access"
}
