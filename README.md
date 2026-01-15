# Azure Governance Landing Zone (Hub-Spoke + Policy-as-Code)

## Background
This project simulates a compliance-first Azure landing zone for regulated environments in Singapore (e.g., finance), focusing on governance guardrails and network isolation.

## Architecture (Hub-Spoke)
- Hub VNet: centralized egress and shared security services
- Spoke VNets: Prod / Non-Prod, no direct Internet access (route through Hub)
> Diagram will be added in `docs/architecture/`.

## Governance Guardrails (Azure Policy-as-Code)
1. Allowed location: `southeastasia` only  
2. Deny Public IP creation in spoke subnets  
3. Require tags: `CostCenter` and `Owner`

## DevSecOps (GitHub Actions)
- On PR: `terraform fmt/validate/plan`
- IaC security scan with Checkov (show a failed pipeline as evidence)

## Evidence
See `docs/evidence.md` for screenshots/GIFs proving policy enforcement and pipeline gating.
