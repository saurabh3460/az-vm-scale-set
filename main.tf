locals {
  rg_name = data.azurerm_resource_group.az.name
  rg_location = data.azurerm_resource_group.az.location
}


resource "azurerm_virtual_network" "vmss_net" {
  name                = "example-network"
  resource_group_name = local.rg_name
  location            = local.rg_location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vmss_net.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "cluster1" {
  name = "vmss"
  resource_group_name = local.rg_name
  location = local.rg_location
  sku = "Standard_F2"
  instances = 2
  admin_username = "adminuser"

  admin_ssh_key {
    username = "adminuser"
    public_key = data.tls_public_key.pub_key.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "20.04.6-LTS"
    version = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }

  network_interface {
    name = "vmss-ni"
    primary = true
    ip_configuration {
      name = "internal"
      primary = true
      subnet_id = azurerm_subnet.internal.id
    }
  }

}