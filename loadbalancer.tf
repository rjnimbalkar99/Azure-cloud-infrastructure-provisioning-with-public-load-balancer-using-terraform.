#To Create a static public ip address for load balancer
resource "azurerm_public_ip" "lb_public_ip" {
    name = "lb_public_ip"
    resource_group_name = "${var.rgn}"
    location = "${var.location_name}"
    ip_version = "IPv4"
    allocation_method = "Static"
    depends_on = [azurerm_subnet.subnet1]  
}

#To create load balancer
resource "azurerm_lb" "L4_lb" {
  name                = "L4_lb"
  location            = "${var.location_name}"
  resource_group_name = "${var.rgn}"

  frontend_ip_configuration {                                        #Assign public ip address to load balancer 
    name                 = "fe_ip_config"
    public_ip_address_id = "${azurerm_public_ip.lb_public_ip.id}" 
  }
}

#To create backend pool
resource "azurerm_lb_backend_address_pool" "web-1" {
  name            = "web-1"
  loadbalancer_id = "${azurerm_lb.L4_lb.id}"
}

#To associate backend pools to target machines
resource "azurerm_network_interface_backend_address_pool_association" "backend_pool_associ1" {
  ip_configuration_name = "backend_pool_associ1"
  network_interface_id      = azurerm_network_interface.nic1.id
  backend_address_pool_id  = azurerm_lb_backend_address_pool.web-1.id
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_pool_associ2" {
  ip_configuration_name = "backend_pool_associ2"
  network_interface_id      = azurerm_network_interface.nic2.id
  backend_address_pool_id  = azurerm_lb_backend_address_pool.web-1.id
}

#To create load balancer rule
resource "azurerm_lb_rule" "LBRule-1" {
  loadbalancer_id                = "${azurerm_lb.L4_lb.id}"
  name                           = "LBRule-1"
  protocol                       = "Tcp"
  frontend_port                  = 80                                  
  backend_port                   = 80
  frontend_ip_configuration_name = "fe_ip_config"
  backend_address_pool_ids = [ "${azurerm_lb_backend_address_pool.web-1.id}"]
  probe_id = "${azurerm_lb_probe.health-prob_rule.id}"
}

#To create health prob
resource "azurerm_lb_probe" "health-prob_rule" {
  loadbalancer_id = "${azurerm_lb.L4_lb.id}"
  name            = "health-prob_rule"
  port            = 80
  protocol = "Tcp"
  probe_threshold = 5
  interval_in_seconds = 10
  number_of_probes = 3
}