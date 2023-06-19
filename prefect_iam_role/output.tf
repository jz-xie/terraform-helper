# output "IAM_Role_ARN" {
#   value = module.irsa.irsa_iam_role_arn
# }

# output "service_account" {
#   value = module.irsa.service_account
# }

# output "service_account_namespace" {
#   value = module.irsa.namespace
# }

output "job_execution_role_arn" {
  value = aws_iam_role.job_execution_role.arn
}

output "job_roles_arn" {
  value = local.job_roles
}
