terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = "1bb9a2e5-bbd2-4862-9368-532c82c39c9f"
  resource_provider_registrations = "none"
}
