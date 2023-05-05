data "azurerm_resource_group" "az" {
  name = "az"
}


data "tls_public_key" "pub_key" {
  # private_key_pem = var.pub_key_path
  private_key_openssh = file("${var.pub_key_path}")
}