variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "firewall_name" { type = string }
variable "firewall_sku_tier" {
  type    = string
  default = "Basic" # 作品集建议 Basic；生产可写 Standard/Premium
}

variable "firewall_subnet_id" { type = string } # Hub 的 AzureFirewallSubnet
variable "spoke_cidrs" { type = list(string) }  # ["10.1.0.0/16","10.2.0.0/16"]
variable "firewall_mgmt_subnet_id" { type = string }
