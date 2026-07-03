# Evidence Index

This document provides the evidence index for the Azure Governance Landing Zone portfolio project. The screenshots and artifacts below show that the landing zone was designed, deployed, validated, and documented using Azure, Terraform, GitHub Actions, Azure Policy, and Checkov.

## Evidence Location

All screenshots and architecture files are stored in:

`docs/architecture/`

## Naming Standard

Recommended naming format:

`dayXX-area-tool-service-result.png`

Examples:

- `day02-tf-dev-apply-ok.png`
- `day03-dev-logs-azfw-rg-core-query-ok.png`
- `day05-actions-ci-terraform-checkov-ok.png`

Filenames should remain stable once they are referenced in this evidence index or in the README.

---

## Architecture

- [x] Final landing zone architecture diagram
  - `docs/architecture/day06-dev-drawio-landingzone-architecture-diagram-final.png`

- [x] Draw.io source file for the final architecture diagram
  - `docs/architecture/day06-dev-drawio-landingzone-architecture-source.drawio`

---

## Day 1 - Project Bootstrap Complete

Day 1 established the basic project structure and documentation approach.

- [x] Repository structure created
  - `docs/`
  - `infra/`
  - `.github/`

- [x] Terraform toolchain verified
  - `terraform init`
  - `terraform fmt`
  - `terraform validate`

- [x] Initial README structure created
  - Background
  - Architecture
  - Governance
  - DevSecOps
  - Evidence

- [x] Decision log initialized
  - Key architectural choices documented

---

## Day 2 - Hub-Spoke Network Foundation Complete

Day 2 deployed and validated the core hub-spoke network foundation.

### Resource Group and Resource Inventory

- [x] Azure resource group overview captured
  - `docs/architecture/day02-portal-rg-core-overview-ok.png`

### Terraform Deployment Evidence

- [x] Terraform apply completed successfully
  - `docs/architecture/day02-tf-dev-apply-ok.png`

- [x] Terraform plan showed no unexpected changes after deployment
  - `docs/architecture/day02-tf-dev-plan-nochanges.png`

### Hub-Spoke Peering Evidence

- [x] Hub-spoke peering connected
  - `docs/architecture/day02-portal-hub-peering-connected.png`

---

## Day 3 - Centralized Egress Through Azure Firewall and UDR Complete

Day 3 implemented centralized outbound routing through Azure Firewall using user-defined routes.

### Core Route Table Proof

- [x] NonProd spoke default route points to Azure Firewall
  - Route: `0.0.0.0/0 -> Virtual appliance -> Azure Firewall private IP`
  - `docs/architecture/day03-dev-portal-udr-spoke-nonprod-default-to-fw-ok.png`

- [x] Prod spoke default route points to Azure Firewall
  - Route: `0.0.0.0/0 -> Virtual appliance -> Azure Firewall private IP`
  - `docs/architecture/day03-dev-portal-udr-spoke-prod-default-to-fw-ok.png`

### Subnet Association Proof

- [x] NonProd app subnet associated with route table
  - `docs/architecture/day03-dev-portal-udr-spoke-nonprod-assoc-snet-app-ok.png`

- [x] NonProd data subnet associated with route table
  - `docs/architecture/day03-dev-portal-udr-spoke-nonprod-assoc-snet-data-ok.png`

- [x] Prod app subnet associated with route table
  - `docs/architecture/day03-dev-portal-udr-spoke-prod-assoc-snet-app-ok.png`

- [x] Prod data subnet associated with route table
  - `docs/architecture/day03-dev-portal-udr-spoke-prod-assoc-snet-data-ok.png`

### Resource Inventory Proof

- [x] Resource group list showing firewall, policies, Log Analytics, public IPs, route tables, and VNets
  - `docs/architecture/day03-dev-portal-rg-rg-core-resource-list-ok.png`

### Firewall Output Evidence

- [x] Terraform output captured Azure Firewall IP information
  - `docs/architecture/day03-dev-tf-firewall-rg-core-output-ips-ok.png`

### Egress Validation Proof

- [x] VM Run Command output showed outbound traffic using the firewall public IP
  - `docs/architecture/day03-dev-cli-vm-spoke-nonprod-runcommand-egress-ip-ok.png`

### Monitoring and Logging Proof

- [x] Azure Firewall logs captured in Log Analytics
  - `docs/architecture/day03-dev-logs-azfw-rg-core-query-ok.png`

---

## Day 4 - Azure Policy-as-Code and Deny Proof Complete

Day 4 implemented Azure Policy guardrails and validated that the deny policies were enforced.

### Policy Assignment Proof

- [x] Azure Policy assignments visible in the Azure portal
  - `docs/architecture/day04-portal-subscription-policy-assign-ok.png`

### Deny Proof

- [x] Denied resource deployment in a non-allowed region
  - `docs/architecture/day04-cli-deny-location-eastus.png`

- [x] Denied resource group creation when required tags were missing
  - `docs/architecture/day04-cli-deny-tags-missing.png`

- [x] Denied Public IP creation at the resource group scope
  - `docs/architecture/day04-cli-deny-publicip-rg-core.png`

---

## Day 5 - CI/CD PR Gate and Checkov Validation Complete

Day 5 implemented GitHub Actions validation and Checkov scanning as the DevSecOps quality gate.

### Successful CI Evidence

- [x] GitHub Actions CI completed successfully with Terraform and Checkov checks
  - `docs/architecture/day05-actions-ci-terraform-checkov-ok.png`

### Intentional Failure Evidence

- [x] Pull request was blocked by CI after an intentional failure
  - `docs/architecture/day05-actions-ci-pr-blocked-failed.png`

- [x] Checkov failure details captured
  - `docs/architecture/day05-actions-ci-terraform-checkov-failed.png`

---

## Day 6 - Portfolio Packaging Complete

Day 6 packaged the architecture, evidence, and narrative into a portfolio-ready project.

- [x] Final landing zone architecture diagram created
  - `docs/architecture/day06-dev-drawio-landingzone-architecture-diagram-final.png`

- [x] Draw.io source file saved
  - `docs/architecture/day06-dev-drawio-landingzone-architecture-source.drawio`

---

## IT473 Unit 4 Capstone Reuse

This Azure Governance Landing Zone project is reused and adapted as the Azure foundation layer for the IT473 food distributor MVP capstone project.

### Unit 4 Scope

The Unit 4 scope includes:

- Azure landing zone foundation
- Hub-spoke networking
- Centralized egress through Azure Firewall and UDR
- Azure Policy governance baseline
- Terraform deployment evidence
- GitHub Actions and Checkov validation
- Monitoring baseline through Log Analytics

### Later Unit Scope

The remaining capstone work will be added in later units:

- Unit 5: Azure SQL Database, schema, and sample data
- Unit 6: Web front end and API layer
- Unit 7: Key Vault, RBAC, diagnostic settings, and security hardening
- Unit 8: End-to-end integration testing
- Unit 9: Final professional portfolio package

### Capstone Fit

The Azure foundation supports the food distributor MVP by providing a secure and governed environment for future application, database, and monitoring components. The foundation does not complete the full MVP by itself. It prepares the cloud environment that later units will build on.

---

## Evidence Summary

| Area | Evidence |
|---|---|
| Resource organization | Resource group and Azure resource inventory screenshots |
| Network foundation | Hub-spoke peering and VNet evidence |
| Centralized egress | Azure Firewall, UDR, subnet association, and egress validation screenshots |
| Governance | Azure Policy assignment and deny proof screenshots |
| DevSecOps | GitHub Actions, Terraform validation, and Checkov evidence |
| Monitoring | Azure Firewall logs in Log Analytics |
| Portfolio packaging | Final architecture diagram and source file |

---

## Notes

- The project uses lab-scale Azure resources for portfolio and learning purposes.
- Expensive resources, such as Azure Firewall, should be destroyed after screenshots and evidence are captured if they are no longer needed.
- No real customer data, payment data, or production business data is used.
- The project demonstrates cloud governance, security, networking, infrastructure as code, and DevSecOps practices in a controlled lab environment.
