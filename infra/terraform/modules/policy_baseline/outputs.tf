output "baseline_assignment_id" {
  value       = azurerm_subscription_policy_assignment.baseline_subscription.id
  description = "Policy assignment ID for the baseline initiative at subscription scope."
}

output "public_ip_assignment_id" {
  value       = azurerm_resource_group_policy_assignment.deny_public_ip_scoped.id
  description = "Policy assignment ID for the scoped deny-public-ip policy."
}
