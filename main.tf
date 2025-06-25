# Import du groupe de ressources existant
data "azurerm_resource_group" "existing" {
  name = "ozoux-rg"
}

# Plan App Service
data "azurerm_service_plan" "plan" {
  name                = "${var.app_name}-${var.environment}-plan"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.existing.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# Module Azure Container Registry
module "acr" {
  source              = "./modules/acr"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = var.location
  app_name            = var.app_name
  environment         = var.environment
}

# Module MySQL Flexible Server
module "mysql" {
  source                 = "./modules/mysql"
  resource_group_name    = data.azurerm_resource_group.existing.name
  location               = var.location
  app_name               = var.app_name
  environment            = var.environment
  administrator_login    = var.mysql_admin
  administrator_password = var.mysql_password
}

# Module Web App Linux (WordPress Docker)
module "webapp" {
  source              = "./modules/webapp"
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = var.location
  app_name            = var.app_name
  environment         = var.environment
  acr_login_server    = module.acr.login_server
  acr_username        = module.acr.admin_username
  acr_password        = module.acr.admin_password
  mysql_fqdn          = module.mysql.fqdn
  mysql_user          = var.mysql_admin
  mysql_password      = var.mysql_password
  service_plan_id     = azurerm_service_plan.existing.id
}

output "webapp_url" {
  value = module.webapp.url
}
