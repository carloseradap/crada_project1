output "aks_cluster_name" {
  value = module.kubernetes.cluster_name
}

output "acr_login_server" {
  value = module.registry.login_server
}
