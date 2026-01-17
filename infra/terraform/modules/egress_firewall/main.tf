# =========================
# Egress Firewall (Hub)
# - Creates: Public IP, IP Group (spokes), Firewall Policy + rules, Azure Firewall
# - Purpose: enforce spoke egress via firewall (SNAT) and prepare for UDR next hop
# =========================

resource "azurerm_public_ip" "fw_pip" {
  name                = "pip-${var.firewall_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# IP group for all spoke address spaces (e.g. 10.1.0.0/16, 10.2.0.0/16)
resource "azurerm_ip_group" "spokes" {
  name                = "ipg-spokes"
  location            = var.location
  resource_group_name = var.resource_group_name
  cidrs               = var.spoke_cidrs
  tags                = var.tags
}

resource "azurerm_firewall_policy" "policy" {
  name                     = "fwp-${var.firewall_name}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  sku                      = var.firewall_sku_tier
  threat_intelligence_mode = "Alert"
  tags                     = var.tags
}

# -------------------------
# Network rules (L3/L4)
# -------------------------
resource "azurerm_firewall_policy_rule_collection_group" "net_rcg" {
  name               = "rcg-network"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 200

  network_rule_collection {
    name     = "net-allow-dns-and-https"
    action   = "Allow"
    priority = 200

    # Allow DNS to Azure-provided DNS
    rule {
      name                  = "allow-dns"
      protocols             = ["UDP"]
      source_ip_groups      = [azurerm_ip_group.spokes.id]
      destination_ports     = ["53"]
      destination_addresses = ["168.63.129.16/32"]
    }

    # Allow HTTPS outbound (Run Command / general HTTPS demo)
    # Most compatible option:
    rule {
      name                  = "allow-https-outbound"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.spokes.id]
      destination_ports     = ["443"]
      destination_addresses = ["0.0.0.0/0"]
    }

    # If your provider supports service tags here, you can replace the above rule with:
    # rule {
    #   name                  = "allow-azurecloud-443"
    #   protocols             = ["TCP"]
    #   source_ip_groups      = [azurerm_ip_group.spokes.id]
    #   destination_ports     = ["443"]
    #   destination_addresses = ["AzureCloud"]
    # }
  }
}

# -------------------------
# Application rules (L7)
# -------------------------
resource "azurerm_firewall_policy_rule_collection_group" "app_rcg" {
  name               = "rcg-application"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 300

  application_rule_collection {
    name     = "app-allow-web-demo"
    action   = "Allow"
    priority = 300

    rule {
      name        = "allow-ip-check"
      description = "Demo sites to prove egress SNAT via Azure Firewall."

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      source_ip_groups  = [azurerm_ip_group.spokes.id]
      destination_fqdns = ["ifconfig.me", "api.ipify.org", "www.microsoft.com"]
    }
  }
}

# -------------------------
# Azure Firewall instance
# -------------------------
resource "azurerm_firewall" "fw" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "management_ip_configuration" {
  for_each = var.firewall_sku_tier == "Basic" ? [1] : []
  content {
    name                 = "mgmt"
    subnet_id            = var.firewall_mgmt_subnet_id
    public_ip_address_id = azurerm_public_ip.fw_mgmt_pip[0].id
  }
}

  sku_name = "AZFW_VNet"
  sku_tier = var.firewall_sku_tier

  firewall_policy_id = azurerm_firewall_policy.policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "fw_mgmt_pip" {
  count               = var.firewall_sku_tier == "Basic" ? 1 : 0
  name                = "pip-${var.firewall_name}-mgmt"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

