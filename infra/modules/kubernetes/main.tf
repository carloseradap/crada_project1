resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-dns"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

network_profile {
  network_plugin     = "azure"
  load_balancer_sku  = "standard"
  service_cidr       = "10.1.0.0/16"     # Outside your VNet range
  dns_service_ip     = "10.1.0.10"
  docker_bridge_cidr = "172.17.0.1/16"
}

  oidc_issuer_enabled       = true
  workload_identity_enabled = false
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
