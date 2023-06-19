# resource "kubernetes_role_binding" "dask_operator" {
#   count = var.dask_required ? 1 : 0
#   metadata {
#     name      = "${var.project}-dask"
#     namespace = "prefect"
#     labels    = { "app.kubernetes.io/name" = var.project }
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = "dask-kubernetes-operator"
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = var.project
#     namespace = "prefect"
#   }

#   depends_on = [
#     module.irsa
#   ]

# }


# resource "kubernetes_cluster_role_binding" "dask_operator" {
#   count = var.dask_required ? 1 : 0
#   metadata {
#     name   = "${var.project}-dask-cluster-role-binding"
#     labels = { "app.kubernetes.io/name" = var.project }
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = "dask-cluster-role"
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = var.project
#     namespace = "prefect"
#   }

# }
