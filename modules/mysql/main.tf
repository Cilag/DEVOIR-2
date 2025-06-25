resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "${var.app_name}-${var.environment}-mysql"
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  storage {
    size_gb = 32
  }

  backup_retention_days = 7

  tags = {
    environment = var.environment
    project     = var.app_name
  }
}

output "fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}