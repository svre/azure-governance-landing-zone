data "azurerm_subscription" "current" {}

module "policy_baseline" {
  source = "C:/Users/Administrator/azure-governance-landing-zone/infra/terraform/modules/policy_baseline"

  # Subscription scope must be a resource ID like: /subscriptions/<id>
  subscription_scope_id = data.azurerm_subscription.current.id

  # Make policy follow the environment location automatically (e.g., eastasia)
  allowed_locations = [var.location]

  # Apply Public IP deny at the current RG scope (adjust later when you split RGs)
  public_ip_policy_scope_id = azurerm_resource_group.core.id

  # Exclude Azure Firewall Public IP from denial
  public_ip_not_scopes = [
    module.egress_firewall.firewall_public_ip_id
  ]

  policy_prefix = var.project
}
