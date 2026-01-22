#############################################
# Custom Policy Definitions (Governance)
#############################################

resource "azurerm_policy_definition" "deny_non_allowed_locations" {
  name         = "${var.policy_prefix}-deny-non-allowed-locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny resources outside allowed locations"
  description  = "Denies resources not in the allowed locations list (excluding global)."

  parameters = jsonencode({
    allowedLocations = {
      type     = "Array"
      metadata = { displayName = "Allowed locations" }
    }
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "location", exists = "true" },
        { field = "location", notEquals = "global" },
        { field = "location", notIn = "[parameters('allowedLocations')]" }
      ]
    }
    then = { effect = "Deny" }
  })
}

# Require tags on RESOURCE GROUPS: CostCenter / Owner
resource "azurerm_policy_definition" "deny_rg_missing_costcenter" {
  name         = "${var.policy_prefix}-deny-rg-missing-costcenter"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny resource groups without CostCenter tag"

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Resources/subscriptions/resourceGroups" },
        { field = "tags['CostCenter']", exists = "false" }
      ]
    }
    then = { effect = "Deny" }
  })
}

resource "azurerm_policy_definition" "deny_rg_missing_owner" {
  name         = "${var.policy_prefix}-deny-rg-missing-owner"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny resource groups without Owner tag"

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Resources/subscriptions/resourceGroups" },
        { field = "tags['Owner']", exists = "false" }
      ]
    }
    then = { effect = "Deny" }
  })
}

# Require tags on RESOURCES: CostCenter / Owner
# Using Indexed mode reduces the chance of evaluating unsupported resource types.
resource "azurerm_policy_definition" "deny_res_missing_costcenter" {
  name         = "${var.policy_prefix}-deny-res-missing-costcenter"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny resources without CostCenter tag"

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", notEquals = "Microsoft.Resources/subscriptions/resourceGroups" },
        { field = "tags['CostCenter']", exists = "false" }
      ]
    }
    then = { effect = "Deny" }
  })
}

resource "azurerm_policy_definition" "deny_res_missing_owner" {
  name         = "${var.policy_prefix}-deny-res-missing-owner"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny resources without Owner tag"

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", notEquals = "Microsoft.Resources/subscriptions/resourceGroups" },
        { field = "tags['Owner']", exists = "false" }
      ]
    }
    then = { effect = "Deny" }
  })
}

# Deny Public IP resources + deny NIC configurations that reference a Public IP
resource "azurerm_policy_definition" "deny_public_ip" {
  name         = "${var.policy_prefix}-deny-public-ip"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Deny Public IP and NIC public IP association"

  policy_rule = jsonencode({
    if = {
      anyOf = [
        { field = "type", equals = "Microsoft.Network/publicIPAddresses" },
        {
          allOf = [
            { field = "type", equals = "Microsoft.Network/networkInterfaces" },
            { field = "Microsoft.Network/networkInterfaces/ipConfigurations[*].publicIPAddress.id", exists = "true" }
          ]
        }
      ]
    }
    then = { effect = "Deny" }
  })
}

#############################################
# Initiative (Policy Set): Location + Tags
#############################################

resource "azurerm_policy_set_definition" "baseline" {
  name         = "${var.policy_prefix}-baseline-initiative"
  policy_type  = "Custom"
  display_name = "Landing Zone Baseline Guardrails (Location + Tags)"

  parameters = jsonencode({
    allowedLocations = {
      type     = "Array"
      metadata = { displayName = "Allowed locations" }
    }
  })

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_non_allowed_locations.id
    reference_id         = "allowedLocations"
    parameter_values = jsonencode({
      allowedLocations = { value = "[parameters('allowedLocations')]" }
    })
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_rg_missing_costcenter.id
    reference_id         = "rgCostCenter"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_rg_missing_owner.id
    reference_id         = "rgOwner"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_res_missing_costcenter.id
    reference_id         = "resCostCenter"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_res_missing_owner.id
    reference_id         = "resOwner"
  }
}

#############################################
# Assignments
#############################################

# Subscription-level baseline assignment
resource "azurerm_subscription_policy_assignment" "baseline_subscription" {
  name                 = "${var.policy_prefix}-pa-baseline"
  display_name         = "Landing Zone Baseline (Location + Tags)"
  subscription_id      = var.subscription_scope_id
  policy_definition_id = azurerm_policy_set_definition.baseline.id

  parameters = jsonencode({
    allowedLocations = { value = var.allowed_locations }
  })
}

# Resource-group scoped deny public ip assignment
resource "azurerm_resource_group_policy_assignment" "deny_public_ip_scoped" {
  name                 = "${var.policy_prefix}-pa-deny-public-ip"
  display_name         = "Deny Public IP (Scoped)"
  resource_group_id    = var.public_ip_policy_scope_id
  policy_definition_id = azurerm_policy_definition.deny_public_ip.id

  not_scopes = var.public_ip_not_scopes
}
