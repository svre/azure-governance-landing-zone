resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.project}-dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_monitor_diagnostic_setting" "azfw_diag" {
  name                       = "diag-azfw"
  target_resource_id         = module.egress_firewall.firewall_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log { category = "AZFWApplicationRule" }
  enabled_log { category = "AZFWNetworkRule" }
  enabled_log { category = "AZFWDnsQuery" }
}
