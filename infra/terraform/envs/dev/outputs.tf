output "hub_vnet" {
  value = module.network_hub.hub_vnet_name
}

output "spoke_prod_vnet_id" {
  value = module.spoke_prod.spoke_vnet_id
}

output "spoke_nonprod_vnet_id" {
  value = module.spoke_nonprod.spoke_vnet_id
}
