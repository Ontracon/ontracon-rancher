resource "azurerm_lb" "lb" {
  resource_group_name = data.azurerm_resource_group.MyRG.name
  name                = "lsy-rancher-mgmt-lb"
  location            = var.location

  frontend_ip_configuration {
    name                          = "Rancher-Frontend"
    private_ip_address            = "10.5.232.140"
    subnet_id                     = data.azurerm_subnet.MyNet.id
    private_ip_address_allocation = "static"

  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = data.azurerm_resource_group.MyRG.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "Rancher-Nodes"
}

resource "azurerm_lb_rule" "lb_rulei1" {
  resource_group_name            = data.azurerm_resource_group.MyRG.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http"
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "Rancher-Frontend"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.lb_probe1.id
  depends_on                     = [azurerm_lb_probe.lb_probe1]
}

resource "azurerm_lb_rule" "lb_rule2" {
  resource_group_name            = data.azurerm_resource_group.MyRG.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "https"
  protocol                       = "tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "Rancher-Frontend"
  enable_floating_ip             = false
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backend_pool.id
  idle_timeout_in_minutes        = 5
  probe_id                       = azurerm_lb_probe.lb_probe2.id
  depends_on                     = [azurerm_lb_probe.lb_probe2]
}



resource "azurerm_lb_probe" "lb_probe1" {
  resource_group_name = data.azurerm_resource_group.MyRG.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "tcpProbe"
  protocol            = "tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}


resource "azurerm_lb_probe" "lb_probe2" {
  resource_group_name = data.azurerm_resource_group.MyRG.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "tcpProbe"
  protocol            = "tcp"
  port                = 443
  interval_in_seconds = 5
  number_of_probes    = 2
}

