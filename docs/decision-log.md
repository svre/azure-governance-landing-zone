# Decision Log

## D1 - Initial decisions
- Region fixed to southeastasia (data residency / compliance narrative)
- Network topology: Hub-Spoke for isolation and centralized egress control
- Public IP strategy: forbid in spokes; controlled egress via hub
- Mandatory tags: CostCenter + Owner for accountability and cost tracking
- CI strategy: PR must run terraform plan + Checkov scan (shift-left security)

## D2 - Hub-Spoke foundation decisions
- Chose /16 per VNet (Hub/Prod/NonProd) for future scale (more spokes/subnets, private endpoints, VPN/ER).
- Reserved AzureFirewallSubnet / AzureBastionSubnet / GatewaySubnet upfront to avoid future re-IPing.
- Enabled bidirectional VNet peering with forwarded traffic to support centralized egress in Day3 (UDR + firewall/NVA).

