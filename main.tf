#creates resource group
resource "azurerm_resource_group" "my-rg" {
  name     = "cohort3-uyi-rg"                          #"resource_group_name"             
  location = "eastus2"
  tags     = var.tags
  
}

# Creates virtual network
resource "azurerm_virtual_network" "virtual-network" {
  name                = "my-vnet"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name
  address_space       = ["10.0.0.0/16"]
}

# Creates 3 subnets
resource "azurerm_subnet" "subnets" {
  #for_each             = { for subnet in var.subnet-names : subnet.name => subnet }
  for_each             = var.subnet-names

  name                 = each.key
  resource_group_name  = azurerm_resource_group.my-rg.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = [each.value]
}


# Creates public-ip address
resource "azurerm_public_ip" "my-public-ip" {
  name                    = "my-public-ip"
  location                = azurerm_resource_group.my-rg.location
  resource_group_name     = azurerm_resource_group.my-rg.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

#create 3 network interface cards
resource "azurerm_network_interface" "my-nic" {
  for_each            = var.network-interface-card

  name                = each.value
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

  ip_configuration {
    name                          = "${each.value}-ipconfig"        
    subnet_id                     = azurerm_subnet.subnets[each.key].id
    private_ip_address_allocation = "Dynamic"

    #public_ip_address_id = each.key == "web-subnet" ? azurerm_public_ip.my-public-ip.id : null
    public_ip_address_id = var.virtual-machine-name[each.key] == "web-vm" ? azurerm_public_ip.my-public-ip.id : null

  }
}
  
# Creates network security groups (NSGs)
resource "azurerm_network_security_group" "nsg" {
  #for_each = { for subnet in var.subnet-names : subnet.name => subnet }
  for_each            = var.subnet-names

  name                = "${each.key}-nsg"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

    dynamic "security_rule" {
    for_each                     = var.nsg-rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}


# Defines NSGs association with subnets
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  #for_each = { for subnet in var.subnet-names : subnet.name => subnet }
  for_each                  = var.subnet-names

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

#creates 3 virtual machines
resource "azurerm_virtual_machine" "my-vms" {
  for_each              = var.virtual-machine-name
  

  name                  = each.value                  
  location              = azurerm_resource_group.my-rg.location
  resource_group_name   = azurerm_resource_group.my-rg.name                    
  network_interface_ids = [azurerm_network_interface.my-nic[each.key].id]
  vm_size               = var.vm-size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-${each.value}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = each.value                    
    admin_username = var.admin-username
    admin_password = var.admin-password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}
