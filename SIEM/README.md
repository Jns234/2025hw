# The SIEM solution
The SIEM solution for this project is Azure Sentinel.
The whole infrstructure is setup in Terraform, excluding App Registrations.
A complete list of what the terraform handles:
 - Resource groups
 - Log Analytics Workspace
 - Data Collection Endpoint
 - Tables
 - Data Collection Rules
 - Role Assignment for the Data Collection Rule
 - Log Analytics Workspace onboarding to Sentinel

To 

https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build

https://learn.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal
