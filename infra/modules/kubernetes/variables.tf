variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for AKS"
  type        = string
}

variable "acr_id" {
  description = "ID of the Azure Container Registry"
  type        = string
}
