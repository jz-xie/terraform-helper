

# data "aws_eks_cluster" "bigdata_eks_production" {
#   name = local.production_eks
# }

# data "aws_eks_cluster_auth" "bigdata_eks_production" {
#   name = local.production_eks
# }

provider "aws" {
  region = var.aws_region
}


# provider "kubernetes" {
#   alias                  = "staging"
#   host                   = data.aws_eks_cluster.bigdata_eks_staging.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.bigdata_eks_staging.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.bigdata_eks_staging.token
# }

# provider "kubernetes" {
#   alias                  = "production"
#   host                   = data.aws_eks_cluster.bigdata_eks_production.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.bigdata_eks_production.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.bigdata_eks_production.token
# }


provider "kubernetes" {
  alias                  = "bigdata-eks-staging"
  host                   = data.aws_eks_cluster.this[local.eks_clusters[0]].endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this[local.eks_clusters[0]].certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this[local.eks_clusters[0]].token
}

provider "kubernetes" {
  alias                  = "bigdata-eks-production"
  host                   = data.aws_eks_cluster.this[local.eks_clusters[1]].endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this[local.eks_clusters[1]].certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this[local.eks_clusters[1]].token
}
