#To get public ip of load balancer
data "azurerm_public_ip" "lb_pub" {
  name = "${azurerm_public_ip.lb_public_ip.name}"
  resource_group_name = "${var.rgn}"
}

output "lb_publicIP"{
    value = data.azurerm_public_ip.lb_pub.ip_address
}

#To get the private ip address of the VM1
data "azurerm_network_interface" "VM1_pri" {
  name = "${azurerm_network_interface.nic1.name}"
  resource_group_name = "${var.rgn}"
  depends_on = [azurerm_network_interface.nic1]
}

output "VM1_private_ip"{
    value = data.azurerm_network_interface.VM1_pri.private_ip_address
}

#To get the private ip address of the VM2
data "azurerm_network_interface" "VM2_pri" {
  name = "${azurerm_network_interface.nic2.name}"
  resource_group_name = "${var.rgn}"
  depends_on = [azurerm_network_interface.nic2]
}

output "VM2_private_ip"{
    value = data.azurerm_network_interface.VM2_pri.private_ip_address
}