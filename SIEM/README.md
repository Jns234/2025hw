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
 - Storage Accounts



To start developing locally, one must log into Azure CLI (which probably has to be installed separately) with the appropriate subscription selected and export the following variables in their CLI:
```
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_SUBSCRIPTION_ID=""
export ARM_TENANT_ID="
```
Then the Terraform environment must be initialized:
```
terraform init
```
And now the real fun begins, the terraform configuration can now be further developed. First check for changes the new configuration makes:
```
terraform plan -out=tfplan
```
and if the planned changes are satisfactory:
```
terraform apply "tfplan"
```
## The setup
When starting from scratch, it makes sense to store the **tfstate** file in an Azure Storage account that's inaccessible to the public, this provides a secure way to keep the state without having it store locally and bummping into state conflicts. The terraform configuration for that is in the `SIEM/terraform_tfstate` folder. For setup the same flow as mentioned above is used. Once the Storage Account is set up, the name of the storage account must be used for the backend in the `SIEM/terraform/main.tf`




https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build

https://learn.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal
