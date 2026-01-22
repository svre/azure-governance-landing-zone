variable "subscription_scope_id" {
  type        = string
  description = "Subscription scope resource ID. Example: /subscriptions/<SUBSCRIPTION_ID>"
}

variable "allowed_locations" {
  type        = list(string)
  description = "Allowed Azure regions for resources (used by the location guardrail)."
  default     = ["eastasia"]
}

variable "public_ip_policy_scope_id" {
  type        = string
  description = "Scope where the Public IP deny policy assignment will be applied. Typically a resource group ID."
}

variable "public_ip_not_scopes" {
  type        = list(string)
  description = "Resource IDs to exclude from the Public IP deny assignment (e.g., Azure Firewall Public IP)."
  default     = []
}

variable "policy_prefix" {
  type        = string
  description = "Prefix for policy definition/assignment names."
  default     = "gov-lz"
}
