#subnet and address prefixes
subnet-names = {
"web-subnet" = "10.0.0.0/24"
"api-subnet" = "10.0.1.0/24"
"db-subnet"  = "10.0.2.0/24"
}

#resource group name
resource-group-name    = "cohort3-uyi-rg"

#virtual network name
virtual-network-name   = "my-vnet"

#username
admin-username         = "adminuser"

#password
admin-password         = "1AAnaconda123."

#address space for virtual network
address-space = ["10.0.0.0/16"]

#location
location = "eastus2"

#tags
tags = {
    owner        = "uyi"
    environment  = "dev"
    date_created = "5/6/2023"
}

#network interface card
network-interface-card = {
  "web-subnet" = "web-nic"
  "api-subnet" = "api-nic"
  "db-subnet"  = "db-nic"

}

#network security rules
# network-security-group = {
#   "web-subnet"  = "web-nsg"
#   "api-subnet"  = "api-nsg"
#   "db-subnet"   = "db-nsg"
#   }

  #virtual machines
  virtual-machine-name = {
    "web-subnet"  = "web-vm"
    "api-subnet"  = "api-vm"
    "db-subnet"   = "db-vm"
  }

nsg-rules = {
    "AllowWebServerInboundHTTP"  = {
      name                       = "AllowWebServerInboundHTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/24"
    },

     "AllowWebServerToAPIServerSSH"    = {
      name                             = "AllowWebServerToAPIServerSSH"
      priority                         = 200
      direction                        = "Inbound"
      access                           = "Allow"
      protocol                         = "Tcp"
      source_port_range                = "*"
      destination_port_range           = "22"
      source_address_prefix            = "10.0.0.0/24"
      destination_address_prefix       = "10.0.1.0/24"
    },

  "AllowAPIServerToDBServerSSH" = {
    name                       = "AllowAPIServerToDBServerSSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }

  "AllowDBServerToAPIServerSSH" = {
    name                       = "AllowDBServerToAPIServerSSH"
    priority                   = 400
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }

  "AllowAPIServerToWebServerSSH" = {
    name                       = "AllowAPIServerToWebServerSSH"
    priority                   = 500
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.0.0/24"
  }

  "DenyWebServerToDBServerSSH" = {
    name                       = "DenyWebServerToDBServerSSH"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }

  "DenyDBServerToWebServerSSH" = {
    name                       = "DenyDBServerToWebServerSSH"
    priority                   = 700
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.0.0/24"
  }

  "DenyInternetToDBServerHTTP" = {
    name                       = "DenyInternetToDBServerHTTP"
    priority                   = 800
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  "DenyDBServerToInternetHTTP" = {
    name                       = "DenyDBServerToInternetHTTP"
    priority                   = 900
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  "DenyAPIServerToInternetHTTP" = {
    name                       = "DenyAPIServerToInternetHTTP"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  "DenyInternetToAPIServerHTTP" = {
    name                       = "DenyInternetToAPIServerHTTP"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }
}

