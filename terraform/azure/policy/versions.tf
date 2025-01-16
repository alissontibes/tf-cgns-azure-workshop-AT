terraform {
  required_version = ">= 0.14.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    checkpoint = {
      source = "CheckPointSW/checkpoint"
      version = "~> 2.8.1"
    }
    random = {
      version = "~> 3.5.1"
    }
  }
}