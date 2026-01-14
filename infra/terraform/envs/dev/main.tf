locals {
  tags = {
    CostCenter = "CC-001"
    Owner      = "your-name"
    Env        = "dev"
  }
}

resource "azurerm_resource_group" "hub" {
  name     = "rg-${var.project}-hub"
  location = var.location
  tags     = local.tags
}

