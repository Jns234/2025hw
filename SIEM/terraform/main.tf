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

resource "azurerm_log_analytics_workspace" "log_ingestion_law" {
  name                = "log-ingestion-law"
  location            = azurerm_resource_group.log_ingestion.location
  resource_group_name = azurerm_resource_group.log_ingestion.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_workspace_table" "log_ingestion_table" {
  workspace_id            = azurerm_log_analytics_workspace.log_ingestion_law.id
  name                    = "Ingested_CL"
  retention_in_days       = 8
}

resource "azurerm_monitor_data_collection_endpoint" "log_ingestion_mdce" {
  name                          = "log-ingestion-mdce"
  resource_group_name           = azurerm_resource_group.log_ingestion.name
  location                      = azurerm_resource_group.log_ingestion.location
  public_network_access_enabled = true
  description                   = "DCE for log ingestion"

}

#resource "azurerm_monitor_data_collection_rule" "log_ingestion_dcr" {
#  name                        = "log-ingestion-dcr"
#  resource_group_name         = azurerm_resource_group.log_ingestion.name
#  location                    = azurerm_resource_group.log_ingestion.location
#  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.log_ingestion_mdce.id
#
#    destinations {
#    log_analytics {
#      workspace_resource_id = azurerm_log_analytics_workspace.log_ingestion_law.id
#      name                  = "log-ingestion-destination-log"
#    }
#  }
#
#  data_flow {
#    streams       = ["Custom-MyTableRawData"]
#    destinations  = ["log_analytics"]
#  }
#
#}