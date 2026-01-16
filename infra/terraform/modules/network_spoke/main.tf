resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.spoke_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = var.subnet_app_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.subnet_app]
}

resource "azurerm_subnet" "data" {
  name                 = var.subnet_data_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.subnet_data]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}
