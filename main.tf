terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.71.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure_ad_ds_rg" {
  name     = "azure-ad-ds-rg"
  location = "westus2"
}

resource "azurerm_virtual_network" "azure_ad_ds_vnet" {
  name                = "azure-ad-ds-vnet"
  resource_group_name = azurerm_resource_group.azure_ad_ds_rg.name
  location            = azurerm_resource_group.azure_ad_ds_rg.location
  address_space       = ["10.1.0.0/24", "10.2.0.0/24", "10.3.0.0/24"]
}

resource "azurerm_subnet" "azure_ad_ds_management_subnet" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.azure_ad_ds_rg.name
  virtual_network_name = azurerm_virtual_network.azure_ad_ds_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "azure_ad_ds_workloads_subnet" {
  name                 = "workloads"
  resource_group_name  = azurerm_resource_group.azure_ad_ds_rg.name
  virtual_network_name = azurerm_virtual_network.azure_ad_ds_vnet.name
  address_prefixes     = ["10.2.0.0/24"]
}

resource "azurerm_subnet" "azure_ad_ds_bastion_subnet" {
  name = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.azure_ad_ds_rg.name
  virtual_network_name = azurerm_virtual_network.azure_ad_ds_vnet.name
  address_prefixes     = ["10.3.0.0/24"]
}