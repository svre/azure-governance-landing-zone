output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "subnet_app_id" {
  value = azurerm_subnet.app.id
}

output "subnet_data_id" {
  value = azurerm_subnet.data.id
}

output "spoke_vnet_name" {
  value = azurerm_virtual_network.spoke.name
}

