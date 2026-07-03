# Decision Log

This document records the main architecture, governance, security, and DevSecOps decisions made for the Azure Governance Landing Zone portfolio project.

---

## D1 - Region and project scope

**Decision**

Use `eastasia` as the lab deployment region because of subscription availability and lab constraints. Use `southeastasia` as the target business narrative for a Singapore / regulated industry scenario.

**Rationale**

The lab region reflects what was available in the Azure subscription. The target narrative keeps the architecture aligned with a realistic regulated-industry use case.

**Trade-off**

The lab deployment region and business narrative region are not identical. This is acceptable for a portfolio project because the design pattern can be adapted to other Azure regions.

---

## D2 - Hub-spoke network topology

**Decision**

Use a hub-spoke network model with one hub VNet and separate production and non-production spoke VNets.

**Rationale**

Hub-spoke design supports centralized security, shared services, network isolation, and future workload expansion.

**Trade-off**

Hub-spoke networking is more complex than a flat VNet design, but it better demonstrates enterprise cloud architecture and governance.

---

## D3 - IP address and subnet design

**Decision**

Use `/16` address spaces for the hub, production spoke, and non-production spoke VNets. Reserve required subnets for Azure Firewall, Bastion, gateway services, shared services, application workloads, and data workloads.

**Rationale**

Larger VNet address ranges make the design easier to expand. Reserved subnets reduce the risk of future rework when adding security, connectivity, or shared platform services.

**Trade-off**

The lab does not use all address space immediately, but the structure is easier to scale and explain.

---

## D4 - Centralized egress through Azure Firewall and UDR

**Decision**

Use Azure Firewall Basic in the hub and force spoke subnet outbound traffic through user-defined routes. The route `0.0.0.0/0` points to the Azure Firewall private IP as a virtual appliance.

**Rationale**

This demonstrates controlled egress, no direct Internet path from spoke subnets, and a centralized inspection point for outbound traffic.

**Trade-off**

Azure Firewall has cost impact, so it is used only for lab evidence and can be destroyed after screenshots are captured.

---

## D5 - Azure Policy-as-Code guardrails

**Decision**

Implement Azure Policy guardrails as code using custom policy definitions and a policy initiative.

**Rationale**

Policy-as-Code keeps governance rules version-controlled and reviewable. The project enforces location restrictions, required tags, and denial of unnecessary public IP creation.

**Trade-off**

The policy design uses lab-scale controls rather than a full enterprise policy framework. This keeps the portfolio project focused and manageable.

---

## D6 - Public IP restriction and exception handling

**Decision**

Deny public IP creation in scoped areas while allowing an exception for the Azure Firewall public IP.

**Rationale**

Spoke workloads should not receive direct public exposure. Azure Firewall still needs a public IP for controlled outbound egress.

**Trade-off**

The exception is acceptable in the lab because the firewall is the centralized egress control. In a larger production design, hub and spoke resource groups would likely be separated more strictly.

---

## D7 - Monitoring and logging

**Decision**

Use Log Analytics to capture Azure Firewall log categories, including network rule, application rule, and DNS query logs.

**Rationale**

Monitoring evidence proves that network egress is not only designed but also observable. This supports auditability and operational troubleshooting.

**Trade-off**

The lab focuses on firewall logs first. Application and database telemetry will be added later when workload services are deployed.

---

## D8 - Terraform and repeatable deployment

**Decision**

Use Terraform as the infrastructure-as-code tool for the landing zone.

**Rationale**

Terraform supports repeatable deployment, code review, drift detection through `terraform plan`, and easier cleanup through `terraform destroy`.

**Trade-off**

Terraform adds learning and setup overhead, but it is a strong fit for cloud engineering and DevOps portfolio evidence.

---

## D9 - GitHub Actions and Checkov PR gate

**Decision**

Use GitHub Actions to run Terraform formatting, validation, planning, and Checkov scanning.

**Rationale**

A CI/CD gate demonstrates shift-left security and prevents infrastructure changes from being merged without basic validation.

**Trade-off**

The workflow is intentionally lightweight. It is not a full enterprise release pipeline, but it is sufficient to demonstrate DevSecOps discipline.

---

## D10 - Evidence-first portfolio documentation

**Decision**

Maintain screenshots, an evidence index, an architecture diagram, and a decision log as part of the repository.

**Rationale**

The project is intended to be understandable to instructors, interviewers, and hiring managers. Evidence-based documentation makes the work easier to verify.

**Trade-off**

Documentation requires extra time, but it makes the portfolio much stronger than code-only evidence.

---

## D11 - Capstone reuse decision

**Decision**

Reuse and adapt this Azure Governance Landing Zone as the Unit 4 foundation layer for the IT473 food distributor MVP capstone project.

**Rationale**

The landing zone directly supports the capstone foundation requirements, including resource organization, hub-spoke networking, governance controls, monitoring readiness, Terraform deployment evidence, and GitHub Actions validation.

**Trade-off**

This repository does not complete the full capstone MVP by itself. The data layer, application/API layer, security hardening, and integration testing will be added in later units.

---

## D12 - Scope control

**Decision**

Keep the landing zone focused on cloud foundation, governance, egress control, monitoring, and DevSecOps. Do not add the e-commerce application, SQL schema, or API into this repository section prematurely.

**Rationale**

The capstone work needs to remain balanced across later units. Unit 4 covers the Azure foundation, while later units add data, application, security hardening, and testing.

**Trade-off**

The project is not a complete production e-commerce system at this stage. It is a secure and governed foundation that later workload components can build on.

---

## Summary of key trade-offs

| Decision area | Chosen approach | Main trade-off |
|---|---|---|
| Region | Lab in eastasia, narrative in southeastasia | Lab constraint differs from business narrative |
| Network | Hub-spoke topology | More complex than flat networking |
| Egress | Azure Firewall Basic and UDR | Cost impact during lab deployment |
| Governance | Azure Policy-as-Code | Simplified compared with enterprise-scale policy |
| DevSecOps | GitHub Actions and Checkov | Lightweight but portfolio-appropriate |
| Documentation | Evidence-first README, screenshots, and decision log | More documentation effort |
| Capstone fit | Reuse as Unit 4 foundation | Later units still need workload implementation |
