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
  location = "southcentralus"
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
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.azure_ad_ds_rg.name
  virtual_network_name = azurerm_virtual_network.azure_ad_ds_vnet.name
  address_prefixes     = ["10.3.0.0/24"]
}

resource "azurerm_public_ip" "azure_ad_ds_pip" {
  name                = "azure-ad-ds-pip"
  resource_group_name = azurerm_resource_group.azure_ad_ds_rg.name
  location            = azurerm_resource_group.azure_ad_ds_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "azure_ad_ds_bastion" {
  name                = "azure-ad-ds-bastion"
  resource_group_name = azurerm_resource_group.azure_ad_ds_rg.name
  location            = azurerm_resource_group.azure_ad_ds_rg.location

  ip_configuration {
    name                 = "azure-ad-ds-bastion-ipc"
    subnet_id            = azurerm_subnet.azure_ad_ds_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.azure_ad_ds_pip.id
  }
}