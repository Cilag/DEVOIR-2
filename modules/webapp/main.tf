resource "azurerm_linux_web_app" "webapp" {
  name                = "${var.app_name}-${var.environment}-webapp"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true

    # Specify full image name (including tag) using new property
    application_stack {
      docker_image_name = "${var.acr_login_server}/wordpress-custom:v1"
    }

    # Use Managed Identity for ACR auth
    container_registry_use_managed_identity = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = "80"
    WORDPRESS_DB_HOST                   = var.mysql_fqdn
    WORDPRESS_DB_USER                   = "${var.mysql_user}@${split(".", var.mysql_fqdn)[0]}"
    WORDPRESS_DB_PASSWORD               = var.mysql_password
  }
}