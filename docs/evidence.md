# Evidence Index

## Architecture
- [ ] Hub-Spoke diagram (draw.io) saved in `docs/architecture/` (TODO)

## Policy Enforcement (Day4 TODO)
- [ ] Screenshot/GIF: “Request Disallowed by Policy” when creating forbidden resource (TODO)

## CI/CD (Day5 TODO)
- [ ] Screenshot: GitHub Actions PR check running terraform fmt/validate/plan (TODO)
- [ ] Screenshot: Failed pipeline when policy/security rule is violated (Checkov/tfsec) (TODO)

---

## Day1 - Project Bootstrap ✅
- [x] Repo structure created (docs/infra/.github)
- [x] Terraform toolchain verified (init/fmt/validate)
- [x] Initial README skeleton created (background/architecture/governance/devsecops/evidence)
- [x] Decision log initialized (key architectural choices)

---

## Day2 - Hub-Spoke Network Foundation ✅
- [x] Hub subnets created (Firewall/Bastion/Gateway/Shared)
  - `docs/architecture/d2-hub-subnets.png`
- [x] Hub peerings connected (Hub <-> Prod/NonProd)
  - `docs/architecture/day2-peerings.png`
- [x] Spoke peerings connected
  - Prod: `docs/architecture/d2-spoke-prod-peerings.png`
  - NonProd: `docs/architecture/d2-spoke-nonprod-peerings.png`

---

## Day3 - Centralized Egress via Azure Firewall + UDR ✅
### Core proof: default route enforced
- [x] Route table (NonProd): `0.0.0.0/0 -> Virtual appliance -> 10.0.0.4`
  - `docs/architecture/day3-rt-nonprod-default-to-fw.png`
- [x] Route table (Prod): `0.0.0.0/0 -> Virtual appliance -> 10.0.0.4`
  - `docs/architecture/day3-rt-prod-default-to-fw.png`

### Subnet association proof (UDR bound to subnets)
- [x] Prod subnet -> route table binding
  - `docs/architecture/day3-subnet-assoc-prod-snet-app.png`
  - `docs/architecture/day3-subnet-assoc-prod-snet-data.png`
- [x] NonProd subnet -> route table binding
  - `docs/architecture/day3-subnet-assoc-nonprod-snet-app.png`
  - `docs/architecture/day3-subnet-assoc-nonprod-snet-data.png`

### Resource inventory proof (what was deployed)
- [x] RG resource list (Firewall/Policy/LA/PIPs/RT/VNets)
  - `docs/architecture/day3-rg-core-resource-list.png`

### Strongest proof: SNAT egress IP equals firewall public IP
- [x] VM Run Command output shows egress IP == firewall public IP (SNAT via firewall)
  - `docs/architecture/day3-vm-runcommand-egress-ip.png`

### Audit proof: Firewall logs captured in Log Analytics
- [x] Log Analytics query results show AZFW logs (Network/DNS/Application)
  - `docs/architecture/day3-azfw-logs.png`
