variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "route_table_name" { type = string }
variable "firewall_private_ip" { type = string }

variable "subnet_ids" { type = list(string) } # 需要绑定的子网列表
