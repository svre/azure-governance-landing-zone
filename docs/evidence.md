# Evidence Index

## Architecture
- [ ] Hub-Spoke diagram (draw.io) saved in `docs/architecture/`

## Policy Enforcement
- [ ] Screenshot/GIF: “Request Disallowed by Policy” when creating forbidden resource

## CI/CD
- [ ] Screenshot: GitHub Actions PR check running terraform plan
- [ ] Screenshot: Failed pipeline when policy/security rule is violated

## Day1 - Project Bootstrap
- [x] Repo structure created (docs/infra/.github)
- [x] Terraform toolchain verified (init/fmt/validate)
- [x] Initial README skeleton (background/architecture/governance/devsecops/evidence)
- [x] Decision log initialized (key architectural choices)


## Day2 - Hub-Spoke Network Foundation
- [x] Hub subnets created (Firewall/Bastion/Gateway/Shared)
  - docs/architecture/d2-hub-subnets.png
- [x] Hub peerings connected (Hub <-> Prod/NonProd)
  - docs/architecture/d2-hub-peerings.png
- [x] Spoke peerings connected
  - Prod: docs/architecture/d2-spoke-prod-peerings.png
  - NonProd: docs/architecture/d2-spoke-nonprod-peerings.png
✅ Day2 Hub peerings connected（docs/architecture/day2-peerings.png）