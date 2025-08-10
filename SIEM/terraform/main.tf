# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
  }

  required_version = ">= 1.12.2"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "log_ingestion" {
  name     = "log_ingestion_rg"
  location = "North Europe"
}
