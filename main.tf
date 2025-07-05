resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.prefix
}

module "registry" {
  source              = "./modules/registry"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.prefix
}

module "kubernetes" {
  source              = "./modules/kubernetes"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  prefix              = var.prefix
  subnet_id           = module.network.subnet_id
  acr_id              = module.registry.acr_id
}
