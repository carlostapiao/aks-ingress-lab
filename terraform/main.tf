provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-k8s-lab4"
  location = "centralus"
}

resource "azurerm_container_registry" "acr" {
  name                = "carlos69lamejor"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akslab"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2ps_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}