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

## D3 - Centralized egress (Azure Firewall + UDR) decisions
- Chose Azure Firewall **Basic** for dev/demo to control cost; would use Standard/Premium in production depending on requirements.
- Added **AzureFirewallManagementSubnet** + management public IP (required for Basic SKU) to avoid deployment failure.
- Enforced spoke egress via UDR: default route `0.0.0.0/0` -> Virtual appliance -> Azure Firewall private IP.
- Validation strategy: (1) Route table + subnet association screenshots, (2) VM Run Command `curl ifconfig.me` shows egress IP equals firewall public IP (SNAT), (3) Log Analytics query confirms AZFW logs (Network/DNS/Application).
- Cost-control practice: destroy Day3 resources after evidence capture; keep code for re-deploy.

## D4 - Policy-as-Code (Azure Policy) decisions
- Implemented governance guardrails as code using custom Policy Definitions + an Initiative (Policy Set) to keep rules version-controlled and reviewable.
- Subscription scope: assigned a baseline Initiative to enforce:
  - Allowed locations = eastasia (aligned with current subscription region availability)
  - Mandatory tags (CostCenter, Owner) for resource groups and taggable resources
- Resource group scope: assigned a scoped deny policy for Public IP to reduce attack surface in spokes.
- Exception strategy: excluded the Azure Firewall Public IP via `not_scopes` to avoid blocking required hub egress components (temporary trade-off until RGs are separated into hub vs spoke scopes).
- Enforcement choice: used `Deny` (not Audit) to produce deterministic, reproducible evidence for the portfolio (RequestDisallowedByPolicy).
- Evidence strategy: validated guardrails via CLI negative tests (wrong region, missing tags, public IP creation) and captured Portal assignment screenshots.
