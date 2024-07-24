resource "azurerm_resource_group" "debug" {
  name     = "${var.name}-debug"
  location = var.location
}

resource "azurerm_public_ip" "debug" {
  name                = "debug"
  location            = azurerm_resource_group.debug.location
  resource_group_name = azurerm_resource_group.debug.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "debug" {
  name                = "debug-public"
  location            = azurerm_resource_group.debug.location
  resource_group_name = azurerm_resource_group.debug.name

  ip_configuration {
    name                          = "public"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.debug.id
    subnet_id                     = var.subnet_id
  }
}

resource "azurerm_network_security_group" "debug-ssh" {
  name                = "${var.name}-debug-ssh-sg"
  location            = azurerm_resource_group.debug.location
  resource_group_name = azurerm_resource_group.debug.name
  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "ssh" {
  network_interface_id      = azurerm_network_interface.debug.id
  network_security_group_id = azurerm_network_security_group.debug-ssh.id
}

resource "azurerm_linux_virtual_machine" "debug" {
  name                = "debug"
  resource_group_name = azurerm_resource_group.debug.name
  location            = azurerm_resource_group.debug.location
  size                = "Standard_B2s"
  admin_username      = var.username
  network_interface_ids = [
    azurerm_network_interface.debug.id
  ]
  admin_ssh_key {
    username   = var.username
    public_key = var.public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}