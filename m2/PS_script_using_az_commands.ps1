#Prefix for resources
$prefix = "cmk"

#Basic variables
$location = "eastus"
$id = Get-Random -Minimum 1000 -Maximum 9999
$resource_group="$prefix-key-vault-$id"
$key_vault_name="$prefix-key-vault-$id"
$storage_account_name="${prefix}sa$id"

#Log into Azure with CLI
az login
#az account set --subscription "YOUR SUBSCRIPTION NAME"

#Create a resource group 
az group create --name $resource_group --location $location

#Create a new Key Vault
az keyvault create -n $key_vault_name -g $resource_group `
  -l $location --sku Standard

az storage account create -n $storage_account_name -g $resource_group `
  -l $location --sku Standard_LRS

az storage account keys list -g $resource_group -n $storage_account_name

$sa_id=$(az storage account show -n $storage_account_name)

$sa_id=$(az storage account show -n $storage_account_name -g $resource_group --query "id")

# $keyVaultSpAppId = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"

az role assignment create --role "Storage Account Key Operator Service Role" `
--assignee 'https://vault.azure.net' --scope $sa_id

# az role assignment delete --role "Storage Account Key Operator Service Role" `
# --assignee <ID of User you want to remove this role from> --scope $sa_id

az keyvault storage add --vault-name $key_vault_name `
-n $storage_account_name `
--active-key-name key1 `
--auto-regenerate-key --regeneration-period P90D `
--resource-id $sa_id

az storage account show -g $resource_group -n $storage_account_name

az storage account keys list -g $resource_group -n $storage_account_name

# az keyvault storage regenerate-key --vault-name $key_vault_name `
#   --name $storage_account_name --key-name key1

# az storage account keys list -g $resource_group -n $storage_account_name  