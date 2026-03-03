# Terraform: Ubuntu 24 VM + Apache (Australia Central)

This project deploys:
- Resource Group
- Virtual Network + Subnet
- Public IP + NSG (ports 22 and 80)
- 3 Ubuntu 24.04 Linux VMs (`Standard_B2ats_v2`) with password-based SSH login
- Apache2 with a default page showing the VM hostname

## Prerequisites
- Terraform v1.5+
- Azure subscription
- Service principal credentials (same approach as `storage-account-tf`)

## Get `subscriptionId`, `tenantId`, `clientId`, `clientSecret` (Azure CLI)
Use these commands in PowerShell.

```powershell
# 1) subscriptionId and tenantId
$SUBSCRIPTION_ID = az account show --query id -o tsv
$TENANT_ID = az account show --query tenantId -o tsv

# 2) clientId (for an existing service principal by display name)
$SP_NAME = "sp-tf-vm-demo"
$CLIENT_ID = az ad sp list --display-name $SP_NAME --query "[0].appId" -o tsv

# 3) clientSecret (cannot be read for an existing secret; create/reset one)
$CLIENT_SECRET = az ad app credential reset --id $CLIENT_ID --append --query password -o tsv

# 4) export for Terraform
$env:ARM_SUBSCRIPTION_ID = $SUBSCRIPTION_ID
$env:ARM_TENANT_ID = $TENANT_ID
$env:ARM_CLIENT_ID = $CLIENT_ID
$env:ARM_CLIENT_SECRET = $CLIENT_SECRET
```

If you do not already have a service principal, create one:

```powershell
az ad sp create-for-rbac --name "sp-tf-vm-demo" --role Contributor --scopes "/subscriptions/$SUBSCRIPTION_ID" --query "{clientId:appId, clientSecret:password, tenantId:tenant}" -o json
```

## Authentication (Service Principal)
Use either:
- `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`, `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, or
- values in `terraform.tfvars`

## Setup and deployment
1. Copy vars file:
   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```
2. Update `terraform.tfvars` if needed.
3. Deploy:
   ```powershell
   terraform init
   terraform validate
   terraform plan -out tfplan
   terraform apply tfplan
   ```

## Connectivity
After apply, Terraform outputs:
- `vm_names`
- `vm_public_ips`
- `website_urls`
- `ssh_commands`

Open the website in a browser using `website_url`. It displays:
- `Running from <hostname>`

SSH (password-based) uses:
- Username: `azureuser` (default)
- Password: `Password@12345`

## Cleanup
```powershell
terraform destroy -auto-approve
```