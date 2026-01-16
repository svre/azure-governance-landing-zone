variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "spoke_vnet_name" { type = string }
variable "spoke_address_space" { type = string }

variable "subnet_app_name" { type = string }
variable "subnet_app" { type = string }

variable "subnet_data_name" { type = string }
variable "subnet_data" { type = string }

# Hub info for peering
variable "hub_vnet_id" { type = string }
variable "hub_vnet_name" { type = string }
variable "hub_resource_group_name" { type = string }
