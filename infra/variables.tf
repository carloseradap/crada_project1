variable "location" {
  description = "Azure region"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  default     = "devops-rg"
}

variable "prefix" {
  description = "Prefix for naming resources"
  type        = string  
  default     = "devops"
}
