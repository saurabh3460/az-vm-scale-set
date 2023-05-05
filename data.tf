data "azurerm_resource_group" "az" {
  name = "az"
}


data "tls_public_key" "pub_key" {
  private_key_openssh = var.pub_key_path
}