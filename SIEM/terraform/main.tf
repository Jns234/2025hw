# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.1"
    }
    azapi = {
      source = "azure/azapi"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.5.0"
    }
  }

  required_version = ">= 1.12.2"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "azapi" {
  skip_provider_registration = false
}
provider "azuread" {
  tenant_id = "60de868c-e210-483f-9be3-490593ef9d52"
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


resource "azurerm_monitor_data_collection_endpoint" "log_ingestion_mdce" {
  name                          = "log-ingestion-mdce"
  resource_group_name           = azurerm_resource_group.log_ingestion.name
  location                      = azurerm_resource_group.log_ingestion.location
  public_network_access_enabled = true
  description                   = "DCE for log ingestion"

}

resource "azapi_resource" "table" {
  type      = "Microsoft.OperationalInsights/workspaces/tables@2025-02-01"
  parent_id = azurerm_log_analytics_workspace.log_ingestion_law.id
  name      = "Ingested_CL"
  body = {
    properties = {
      plan                 = "Analytics"
      retentionInDays      = 30
      totalRetentionInDays = 30
      schema = {
        name    = "Ingested_CL"
        columns = [
            {
              name = "host"
              type = "string"
            },
            {
              name = "ident"
              type = "string"
            },
            {
              name = "message"
              type = "string"
            },
            {
              name = "TimeGenerated"
              type = "datetime"
            },
        ]
      }
    }
  }
  schema_validation_enabled = true
}


resource "azurerm_monitor_data_collection_rule" "log_ingestion_dcr" {
  name                        = "ingested_dcr"
  resource_group_name         = azurerm_resource_group.log_ingestion.name
  location                    = azurerm_resource_group.log_ingestion.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.log_ingestion_mdce.id

    destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log_ingestion_law.id
      name                  = azurerm_log_analytics_workspace.log_ingestion_law.name
    }
  }

  data_flow {
    built_in_transform = null
    destinations       = [
        azurerm_log_analytics_workspace.log_ingestion_law.name
    ]
    output_stream      = "Custom-Ingested_CL"
    streams            = ["Custom-Ingested_CL"]
    transform_kql      = "source | extend TimeGenerated = now()"
    }

    stream_declaration {
        stream_name = "Custom-Ingested_CL"

        column {
            name = "TimeGenerated"
            type = "datetime"
        }
        column {
            name = "host"
            type = "string"
        }
        column {
            name = "ident"
            type = "string"
        }
        column {
            name = "message"
            type = "string"
        }
        }

}

#import {
#  id = "/subscriptions/346d4e74-e2a3-41a6-aeff-88dae8d0e89d/resourceGroups/log_ingestion_rg/providers/Microsoft.Insights/dataCollectionRules/ingested_dcr/providers/Microsoft.Authorization/roleAssignments/b7168961-afb4-46da-a1ed-2faa811be5c0"
#  to = azurerm_role_assignment.log_ingestion_access
#}


resource "azurerm_role_assignment" "log_ingestion_access" {
  scope                = azurerm_monitor_data_collection_rule.log_ingestion_dcr.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = "c03c0625-3e39-44b0-9f70-6b08becc0cbf"
}