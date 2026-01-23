
locals {
  subnet_map = (can(tomap(var.subnet_ids)) ? tomap(var.subnet_ids) : { for i, id in tolist(var.subnet_ids) : tostring(i) => id })
}


resource "azurerm_route_table" "rt" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_route" "default_to_fw" {
  name                   = "default-to-fw"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

locals {
  subnet_list = can(tolist(var.subnet_ids)) ? tolist(var.subnet_ids) : values(tomap(var.subnet_ids))
}

resource "azurerm_subnet_route_table_association" "assoc" {
  count          = length(local.subnet_list)
  subnet_id      = local.subnet_list[count.index]
  route_table_id = azurerm_route_table.rt.id
}
