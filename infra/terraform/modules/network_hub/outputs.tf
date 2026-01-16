output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "subnet_ids" {
  value = {
    firewall = azurerm_subnet.firewall.id
    bastion  = azurerm_subnet.bastion.id
    gateway  = azurerm_subnet.gateway.id
    shared   = azurerm_subnet.shared.id
  }
}
