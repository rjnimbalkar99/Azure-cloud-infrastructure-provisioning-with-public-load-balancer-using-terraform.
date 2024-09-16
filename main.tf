# To create a resource group
resource "azurerm_resource_group" "rg1" {
    name = "${var.rgn}"
    location = "${var.location_name}"
}

# to create Virtual network
resource "azurerm_virtual_network" "Vnet1" {
    name  = "${var.Vnetn}"
    resource_group_name = "${var.rgn}"
    location = "${var.location_name}"
    address_space = ["10.0.0.0/8"]
    depends_on = [azurerm_resource_group.rg1]
}

# To create a subnet1
resource "azurerm_subnet" "subnet1" {              #Subnet for network interface 1 
    name = "${var.subn}"   
    virtual_network_name = "${var.Vnetn}"
    resource_group_name = "${var.rgn}"
    address_prefixes = ["10.0.0.0/16"]   
    depends_on = [azurerm_virtual_network.Vnet1]
}

# To create a subnet2
resource "azurerm_subnet" "subnet2" {              #Subnet for network interface 2
    name = "${var.subn1}"
    virtual_network_name = "${var.Vnetn}"
    resource_group_name = "${var.rgn}"
    address_prefixes = ["10.10.0.0/16"]  
    depends_on = [azurerm_subnet.subnet1] 
}

