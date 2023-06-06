#defines resource group
variable "resource-group-name" {
  type        = string
  description = "Name of the resource group"
  default     = ""
}

variable "location" {
  type        = string
  description = "location of azure resource"
  default     = "" 
}

variable "tags" {
  type = map(string)
  default = {}
}

#defines virtual network
variable "virtual-network-name" {
  type        = string
  description = "Name of the virtual network"
  default     = ""
}

# Defines the variable for the Vnet_address_space
variable "address-space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = []
}

# Defines the names of the subnets
variable "subnet-names" {
    type   = map(string)
  default = {}
}

#define my NIC
variable "network-interface-card" {
 type = map(string)
 default = {}
 }

 #define NSGs
 variable "nsg-rules" {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = {}
}
 
 #define VMs
 variable "virtual-machine-name" {
  type = map(string)
  default = {}
 }


 variable "admin-username" {
  type = string
  default = ""
}

variable "admin-password" {
  type = string
  default = ""
}

# Defines the size of the VMs
variable "vm-size" {
  description = "Size of the virtual machines"
  default     = "Standard_B1s"
}


