variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "hub_vnet_name" { type = string }
variable "hub_address_space" { type = string }

variable "subnet_firewall" { type = string }
variable "subnet_bastion" { type = string }
variable "subnet_gateway" { type = string }

variable "subnet_shared_name" { type = string }
variable "subnet_shared" { type = string }
