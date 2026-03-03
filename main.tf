terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = [var.virtual_network_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "vm_pip" {
  count               = var.vm_count
  name                = format("%s-%02d-pip", var.vm_name, count.index + 1)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.vm_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  count               = var.vm_count
  name                = format("%s-%02d-nic", var.vm_name, count.index + 1)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "vm_nic_nsg" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.vm_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = format("%s-%02d", var.vm_name, count.index + 1)
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.vm_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "ubuntu-pro-gen1"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {}))
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vm_names" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}

output "vm_public_ips" {
  value = [for pip in azurerm_public_ip.vm_pip : pip.ip_address]
}

output "website_urls" {
  value = [for pip in azurerm_public_ip.vm_pip : "http://${pip.ip_address}"]
}

output "ssh_commands" {
  value = [for pip in azurerm_public_ip.vm_pip : "ssh ${var.admin_username}@${pip.ip_address}"]
}