# Optional when ARM_* environment variables are set
subscription_id    = "xxxx"
tenant_id          = "xxxx"
client_id          = "xxxx"
client_secret      = "xxxx"


resource_group_name  = "rg-loadbalancer-vinodh"
location             = "eastus"
virtual_network_name = "vnet-vm-ausc-demo"
virtual_network_cidr = "10.10.0.0/16"
subnet_name          = "snet-vm"
subnet_cidr          = "10.10.1.0/24"

vm_name              = "vm-ubuntu24-docker"
vm_size              = "Standard_B1ms"
admin_username       = "azureuser"
admin_password       = "Password@12345"