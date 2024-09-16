#To genrate the secret key
resource "tls_private_key" "test_key1" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# To save this privaye key to our local machine and later can use this key to connect to our virtual machine
resource "local_file" "Virtual_machine_key1" {
  filename = "Virtual_machine_key1.pem"
  content = "${tls_private_key.test_key1.private_key_pem}"
}

#To create a availibility set
resource "azurerm_availability_set" "set1" {
  name = "set1"
  location = "${var.location_name}"
  resource_group_name = "${var.rgn}"
}

#To create a Network interface card 1
resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = "${var.location_name}"
  resource_group_name = "${var.rgn}"
  depends_on = [azurerm_subnet.subnet1, azurerm_availability_set.set1]

  ip_configuration {
    name                          = "backend_pool_associ1"              #IP configuration is used to for the backend pools of load balancer 
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

#To create a virtual machine 1
resource "azurerm_linux_virtual_machine" "VM1" {
  name                = "VM1"
  resource_group_name = "${var.rgn}"
  location            = "${var.location_name}"
  size                = "Standard_D2s_v3"
  admin_username      = "rahul"
  user_data = base64encode(file("userdata.sh"))                       #Assign userdata script to VM1
  availability_set_id = "${azurerm_availability_set.set1.id}"         #Assign availability set to VM1
  depends_on = [tls_private_key.test_key1, azurerm_network_interface.nic1]

  network_interface_ids = [
    "${azurerm_network_interface.nic1.id}"                             #Assign the nic1 to VM1
  ]

  admin_ssh_key {
    username   = "rahul"
    public_key = "${tls_private_key.test_key1.public_key_openssh}"     #Assign the private key to VM1 
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

#To create a Network interface card 2
resource "azurerm_network_interface" "nic2" {
  name                = "nic2"
  location            = "${var.location_name}"
  resource_group_name = "${var.rgn}"
  depends_on = [azurerm_subnet.subnet2, azurerm_availability_set.set1]

  ip_configuration {
    name                          = "backend_pool_associ2"              #IP configuration is used to for the backend pools of load balancer 
    subnet_id                     = "${azurerm_subnet.subnet2.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

#To create a virtual machine 2
resource "azurerm_linux_virtual_machine" "VM2" {
  name                = "VM2"
  resource_group_name = "${var.rgn}"
  location            = "${var.location_name}"
  size                = "Standard_D2s_v3"
  admin_username      = "rahul"
  user_data = base64encode(file("userdata1.sh"))                      #Assign the userdata1 script to VM2
  availability_set_id = "${azurerm_availability_set.set1.id}"         #Assign the vavilability set to VM2
  depends_on = [tls_private_key.test_key1, azurerm_network_interface.nic2]

  network_interface_ids = [                                             #Assign the nic2 to VM2
    "${azurerm_network_interface.nic2.id}"
  ]

  admin_ssh_key {                                                      #Assign the private key to VM2
    username   = "rahul"
    public_key = "${tls_private_key.test_key1.public_key_openssh}"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
