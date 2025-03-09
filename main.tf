provider "azurerm" {
  features {}
}

module "azure_org" {
  source              = "./modules/azure_org"
  resource_group_name = "example-resources"
  location           = "West Europe"
}

module "azure_vnet" {
  source              = "./modules/azure_vnet"
  vnet_name           = "example-network"
  address_space       = ["10.0.0.0/16"]
  location           = module.azure_org.location
  resource_group_name = module.azure_org.resource_group_name
}

module "azure_subnet" {
  source              = "./modules/azure_subnet"
  subnet_name         = "internal"
  resource_group_name = module.azure_org.resource_group_name
  vnet_name           = module.azure_vnet.vnet_name
  address_prefixes    = ["10.0.2.0/24"]
}

module "azure_nic" {
  source              = "./modules/azure_nic"
  nic_name            = "example-nic"
  location           = module.azure_org.location
  resource_group_name = module.azure_org.resource_group_name
  subnet_id           = module.azure_subnet.subnet_id
}

module "azure_windows_vm" {
  source              = "./modules/azure_windows_vm"
  vm_name             = "example-machine"
  resource_group_name = module.azure_org.resource_group_name
  location           = module.azure_org.location
  vm_size             = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!"
  nic_id              = module.azure_nic.nic_id
}
