locals {
  tags = {
    CostCenter = "CC-001"
    Owner      = "sorenvale"
    Env        = "dev"
  }
}

resource "azurerm_resource_group" "core" {
  name     = "rg-${var.project}-core"
  location = var.location
  tags     = local.tags
}

module "network_hub" {
  source              = "C:/Users/Administrator/azure-governance-landing-zone/infra/terraform/modules/network_hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  tags                = local.tags

  hub_vnet_name     = "vnet-${var.project}-hub"
  hub_address_space = "10.0.0.0/16"

  subnet_firewall_mgmt = "10.0.0.128/26"
  subnet_firewall      = "10.0.0.0/26"
  subnet_bastion       = "10.0.0.64/26"
  subnet_gateway       = "10.0.1.0/27"
  subnet_shared_name   = "snet-hub-shared"
  subnet_shared        = "10.0.2.0/24"
}

module "spoke_prod" {
  source              = "C:/Users/Administrator/azure-governance-landing-zone/infra/terraform/modules/network_spoke"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  tags                = local.tags

  spoke_vnet_name     = "vnet-${var.project}-spoke-prod"
  spoke_address_space = "10.1.0.0/16"
  subnet_app_name     = "snet-app"
  subnet_app          = "10.1.10.0/24"
  subnet_data_name    = "snet-data"
  subnet_data         = "10.1.20.0/24"

  hub_vnet_id             = module.network_hub.hub_vnet_id
  hub_vnet_name           = module.network_hub.hub_vnet_name
  hub_resource_group_name = azurerm_resource_group.core.name
}

module "spoke_nonprod" {
  source              = "C:/Users/Administrator/azure-governance-landing-zone/infra/terraform/modules/network_spoke"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  tags                = local.tags

  spoke_vnet_name     = "vnet-${var.project}-spoke-nonprod"
  spoke_address_space = "10.2.0.0/16"
  subnet_app_name     = "snet-app"
  subnet_app          = "10.2.10.0/24"
  subnet_data_name    = "snet-data"
  subnet_data         = "10.2.20.0/24"

  hub_vnet_id             = module.network_hub.hub_vnet_id
  hub_vnet_name           = module.network_hub.hub_vnet_name
  hub_resource_group_name = azurerm_resource_group.core.name
}

module "egress_firewall" {
  source              = "C:/Users/Administrator/azure-governance-landing-zone/infra/terraform/modules/egress_firewall"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  tags                = local.tags

  firewall_mgmt_subnet_id = module.network_hub.subnet_ids.firewall_mgmt
  firewall_name           = "azfw-${var.project}-hub"
  firewall_sku_tier       = "Basic"

  firewall_subnet_id = module.network_hub.subnet_ids.firewall
  spoke_cidrs        = ["10.1.0.0/16", "10.2.0.0/16"]
}

module "udr_spoke_prod" {
  source              = "C:/Users/Administrator/azure-governance-landing-zone/infra/terraform/modules/spoke_udr"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  tags                = local.tags

  route_table_name    = "rt-${var.project}-spoke-prod"
  firewall_private_ip = module.egress_firewall.firewall_private_ip
  subnet_ids = {
    app  = module.spoke_prod.subnet_app_id
    data = module.spoke_prod.subnet_data_id
  }

}

module "udr_spoke_nonprod" {
  source              = "C:/Users/Administrator/azure-governance-landing-zone/infra/terraform/modules/spoke_udr"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  tags                = local.tags

  route_table_name    = "rt-${var.project}-spoke-nonprod"
  firewall_private_ip = module.egress_firewall.firewall_private_ip
  subnet_ids = {
    app  = module.spoke_nonprod.subnet_app_id
    data = module.spoke_nonprod.subnet_data_id
  }

}
