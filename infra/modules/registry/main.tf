resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr${random_integer.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}
