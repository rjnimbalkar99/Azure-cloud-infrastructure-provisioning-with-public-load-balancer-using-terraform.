terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1.0"  
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"  
    }
  }
}


provider "azurerm" {
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id

    features {}
}