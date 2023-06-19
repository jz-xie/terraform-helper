data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = compact([
        var.dev_role_arn,
        try(module.bigdata_eks_staging[0].irsa_iam_role_arn, ""),
        try(module.bigdata_eks_production[0].irsa_iam_role_arn, "")
      ])
    }
  }
}

data "aws_iam_policy_document" "final" {
  source_policy_documents = [
    data.aws_iam_policy_document.assume_role_policy.json,
    var.additional_assume_role_policy_statements
  ]
}


resource "aws_iam_role" "job_execution_role" {
  name        = local.job_execution_role_name
  description = "IAM role for Prefect job execution"

  assume_role_policy = data.aws_iam_policy_document.final.json


  tags = {
    project = var.project
  }
}

resource "aws_iam_role_policy_attachment" "irsa" {
  count = var.job_execution_iam_policies != null ? length(var.job_execution_iam_policies) : 0

  policy_arn = var.job_execution_iam_policies[count.index]
  role       = aws_iam_role.job_execution_role.name
}

resource "aws_iam_role_policy_attachment" "prefect_staging_policy_attachment" {
  count      = contains(var.execution_eks_clusters, local.eks_clusters[0]) ? 1 : 0
  role       = aws_iam_role.job_execution_role.name
  policy_arn = data.aws_iam_policy.prefect_storage_staging_access.arn
}

resource "aws_iam_role_policy_attachment" "prefect_production_role_policy_attachment" {
  count      = contains(var.execution_eks_clusters, local.eks_clusters[1]) ? 1 : 0
  role       = aws_iam_role.job_execution_role.name
  policy_arn = data.aws_iam_policy.prefect_storage_production_access.arn
}
