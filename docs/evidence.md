# Evidence Index

## Naming (recommended)
- Format: `dayXX-<source>-<scope>-<what>-<result>.png`
- Directory: `docs/architecture/`
- Notes: Keep filenames stable once referenced here.

---

## Architecture
- [ ] Hub-Spoke diagram (draw.io) saved in `docs/architecture/` (TODO)

---

## Day1 - Project Bootstrap 鉁?
- [x] Repo structure created (docs/infra/.github)
- [x] Terraform toolchain verified (init/fmt/validate)
- [x] Initial README skeleton created (background/architecture/governance/devsecops/evidence)
- [x] Decision log initialized (key architectural choices)

---

## Day2 - Hub-Spoke Network Foundation 鉁?
- [x] Hub subnets created (Firewall/Bastion/Gateway/Shared)
  - `docs/architecture/d2-hub-subnets.png`
- [x] Hub peerings connected (Hub <-> Prod/NonProd)
  - `docs/architecture/day2-peerings.png`
- [x] Spoke peerings connected
  - Prod: `docs/architecture/d2-spoke-prod-peerings.png`
  - NonProd: `docs/architecture/d2-spoke-nonprod-peerings.png`

---

## Day3 - Centralized Egress via Azure Firewall + UDR 鉁?

### Core proof: default route enforced
- [x] Route table (NonProd): `0.0.0.0/0 -> Virtual appliance -> 10.0.0.4`
  - `docs/architecture/day03-dev-portal-udr-spoke-nonprod-default-to-fw-ok.png`
- [x] Route table (Prod): `0.0.0.0/0 -> Virtual appliance -> 10.0.0.4`
  - `docs/architecture/day03-dev-portal-udr-spoke-prod-default-to-fw-ok.png`

### Subnet association proof (UDR bound to subnets)
- [x] Prod subnet -> route table binding
  - `docs/architecture/day03-dev-portal-udr-spoke-prod-assoc-snet-app-ok.png`
  - `docs/architecture/day03-dev-portal-udr-spoke-prod-assoc-snet-data-ok.png`
- [x] NonProd subnet -> route table binding
  - `docs/architecture/day03-dev-portal-udr-spoke-nonprod-assoc-snet-app-ok.png`
  - `docs/architecture/day03-dev-portal-udr-spoke-nonprod-assoc-snet-data-ok.png`

### Resource inventory proof (what was deployed)
- [x] RG resource list (Firewall/Policy/LA/PIPs/RT/VNets)
  - `docs/architecture/day03-dev-portal-rg-rg-core-resource-list-ok.png`

### Strongest proof: SNAT egress IP equals firewall public IP
- [x] VM Run Command output shows egress IP == firewall public IP (SNAT via firewall)
  - `docs/architecture/day03-dev-cli-vm-spoke-nonprod-runcommand-egress-ip-ok.png`

### Audit proof: Firewall logs captured in Log Analytics
- [x] Log Analytics query results show AZFW logs (Network/DNS/Application)
  - `docs/architecture/day03-dev-logs-azfw-rg-core-query-ok.png`

---

## Day4 - Policy-as-Code (Deny Proof) 鉁?

### Assignment proof (Portal)
- [x] Policy assignments visible (Baseline initiative at subscription + Deny Public IP scoped to RG)
  - `docs/architecture/day04-dev-portal-policy-subscription-assignments-ok.png`

### Deny proof (CLI)
- [x] Deny non-allowed region (eastus)
  - `docs/architecture/day04-dev-cli-policy-subscription-location-eastus-deny.png`
- [x] Deny missing required tags (CostCenter/Owner) on resource group creation
  - `docs/architecture/day04-dev-cli-policy-subscription-tags-missing-deny.png`
- [x] Deny Public IP creation at RG scope (scoped assignment)
  - `docs/architecture/day04-dev-cli-policy-rg-core-publicip-deny.png`

---

## Day5 - CI/CD (TODO - not done today)
- [ ] Screenshot: GitHub Actions PR check running terraform fmt/validate/plan (TODO)
- [ ] Screenshot: Failed pipeline when policy/security rule is violated (Checkov/tfsec) (TODO)

