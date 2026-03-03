variable "subscription_id" {
  type        = string
  default     = null
  nullable    = true
  description = "Azure subscription ID"
}

variable "tenant_id" {
  type        = string
  default     = null
  nullable    = true
  description = "Microsoft Entra tenant ID"
}

variable "client_id" {
  type        = string
  default     = null
  nullable    = true
  description = "Service principal app/client ID"
}

variable "client_secret" {
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
  description = "Service principal client secret"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-tf-vm-ausc-demo"
  description = "Resource group name"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

variable "virtual_network_name" {
  type        = string
  default     = "vnet-vm-ausc-demo"
  description = "Virtual network name"
}

variable "virtual_network_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "Virtual network address space"
}

variable "subnet_name" {
  type        = string
  default     = "snet-vm"
  description = "Subnet name"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.10.1.0/24"
  description = "Subnet CIDR"
}

variable "vm_name" {
  type        = string
  default     = "vm-ubuntu24-docker"
  description = "Virtual machine name"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2ats_v2"
  description = "VM size"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "VM admin username"
}

variable "admin_password" {
  type        = string
  default     = "Password@12345"
  sensitive   = true
  description = "VM admin password for SSH password-based authentication"
}