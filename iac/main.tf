terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.32.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "2c9a4fa7-3d46-4c62-b0c6-c5bb820d7f9f"
}


resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources"
  location = "eastus"
}