# Defines terraform provider and version

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"

    }
  }

#azure storage account for terraform tfstate
backend "azurerm" {
  resource_group_name  = "cohort3-uyi-rg"
  storage_account_name = "tfstatevms1194"
  container_name       = "tfstatevmscont"
  key                  = "terraform.tfstate"

 }

}

# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
}