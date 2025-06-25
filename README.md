
# 📦 Déploiement d’une infrastructure N-Tier sur Azure avec Terraform

## 🎯 Objectif

Ce projet vise à déployer automatiquement une architecture N-tier sur Azure, entièrement définie avec Terraform. Il comprend :
- Un registre de conteneurs (Azure Container Registry - ACR)
- Une image Docker personnalisée de WordPress
- Une Web App (Linux) hébergeant WordPress
- Une base de données MySQL Flexible Server
- Deux environnements : **développement** et **production**

---

## 🧱 Architecture

```
                      +----------------------+
                      |     GitHub Repo      |
                      +----------+-----------+
                                 |
                             (Terraform)
                                 |
                +-------------------------------+
                |           Azure               |
                +-------------------------------+
                | Resource Group (my-rg)        |
                |                               |
                |  + ACR (ozouxacr2025)         |
                |  + MySQL Flexible Server      |
                |  + App Service Plan           |
                |  + Web App (Docker container) |
                +-------------------------------+
```

- WordPress utilise une **image Docker personnalisée**, poussée dans ACR.
- La Web App tire cette image depuis ACR à chaque déploiement.
- WordPress est connecté à une base de données MySQL protégée.
- Le code Terraform est structuré pour gérer plusieurs environnements via `terraform.tfvars`.

---

## 🚀 Prérequis

- [Terraform](https://www.terraform.io/downloads)
- [Azure CLI](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- [Docker](https://www.docker.com/products/docker-desktop/)
- Un compte Azure avec un abonnement actif
- Un dépôt GitHub (public ou privé)

---

## 📁 Structure du projet

```
.
├── envs/
│   ├── dev/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
├── modules/
│   ├── acr/
│   ├── mysql/
│   └── webapp/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── README.md
```

---

## 🛠️ Instructions de déploiement

### 1. Authentification Azure

```bash
az login
```

### 2. Initialiser Terraform

```bash
terraform init
```

### 3. Déployer l’environnement "dev"

```bash
terraform apply -var-file="envs/dev/terraform.tfvars"
```

### 4. (Optionnel) Déployer "prod"

```bash
terraform apply -var-file="envs/prod/terraform.tfvars"
```

---

## 🐳 Docker – Image personnalisée

L’image WordPress a été personnalisée avec un thème et poussée vers Azure Container Registry :

```bash
docker build -t ozouxacr2025.azurecr.io/wordpress-custom:v1 .
az acr login --name ozouxacr2025
docker push ozouxacr2025.azurecr.io/wordpress-custom:v1
```

---

## 📸 Capture de l'application

```
PS C:\Users\ozoux\DEVOIR-2> terraform apply -var-file="envs/dev/terraform.tfvars"
data.azurerm_resource_group.existing: Reading...
data.azurerm_resource_group.existing: Read complete after 1s [id=/subscriptions/5f13b879-49c5-44a1-8328-0b128ab8b9a2/resourceGroups/ozoux-rg]
module.acr.azurerm_container_registry.acr: Refreshing state... [id=/subscriptions/5f13b879-49c5-44a1-8328-0b128ab8b9a2/resourceGroups/ozoux-rg/providers/Microsoft.ContainerRegistry/registries/ozouxapp2dev2025devacr]
module.mysql.azurerm_mysql_flexible_server.mysql: Refreshing state... [id=/subscriptions/5f13b879-49c5-44a1-8328-0b128ab8b9a2/resourceGroups/ozoux-rg/providers/Microsoft.DBforMySQL/flexibleServers/ozouxapp2dev2025-dev-mysql]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_service_plan.plan will be created
  + resource "azurerm_service_plan" "plan" {
      + id                              = (known after apply)
      + kind                            = (known after apply)
      + location                        = "francecentral"
      + maximum_elastic_worker_count    = (known after apply)
      + name                            = "ozouxapp2dev2025-dev-plan"
      + os_type                         = "Linux"
      + per_site_scaling_enabled        = false
      + premium_plan_auto_scale_enabled = false
      + reserved                        = (known after apply)
      + resource_group_name             = "ozoux-rg"
      + sku_name                        = "F1"
      + worker_count                    = (known after apply)
    }

  # module.webapp.azurerm_linux_web_app.webapp will be created
  + resource "azurerm_linux_web_app" "webapp" {
      + app_settings                                   = {
          + "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
          + "WEBSITES_PORT"                       = "80"
          + "WORDPRESS_DB_HOST"                   = "ozouxapp2dev2025-dev-mysql.mysql.database.azure.com"
          + "WORDPRESS_DB_PASSWORD"               = "Azerty123!"
          + "WORDPRESS_DB_USER"                   = "wpadmin@ozouxapp2dev2025-dev-mysql"
        }
      + client_affinity_enabled                        = false
      + client_certificate_enabled                     = false
      + client_certificate_mode                        = "Required"
      + custom_domain_verification_id                  = (sensitive value)
      + default_hostname                               = (known after apply)
      + enabled                                        = true
      + ftp_publish_basic_authentication_enabled       = true
      + hosting_environment_id                         = (known after apply)
      + https_only                                     = true
      + id                                             = (known after apply)
      + key_vault_reference_identity_id                = (known after apply)
      + kind                                           = (known after apply)
      + location                                       = "francecentral"
      + name                                           = "ozouxapp2dev2025-dev-webapp"
      + outbound_ip_address_list                       = (known after apply)
      + outbound_ip_addresses                          = (known after apply)
      + possible_outbound_ip_address_list              = (known after apply)
      + possible_outbound_ip_addresses                 = (known after apply)
      + public_network_access_enabled                  = true
      + resource_group_name                            = "ozoux-rg"
      + service_plan_id                                = (known after apply)
      + site_credential                                = (sensitive value)
      + virtual_network_backup_restore_enabled         = false
      + webdeploy_publish_basic_authentication_enabled = true
      + zip_deploy_file                                = (known after apply)

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + site_config {
          + always_on                               = true
          + container_registry_use_managed_identity = true
          + default_documents                       = (known after apply)
          + detailed_error_logging_enabled          = (known after apply)
          + ftps_state                              = "Disabled"
          + http2_enabled                           = false
          + ip_restriction_default_action           = "Allow"
          + linux_fx_version                        = (known after apply)
          + load_balancing_mode                     = "LeastRequests"
          + local_mysql_enabled                     = false
          + managed_pipeline_mode                   = "Integrated"
          + minimum_tls_version                     = "1.2"
          + remote_debugging_enabled                = false
          + remote_debugging_version                = (known after apply)
          + scm_ip_restriction_default_action       = "Allow"
          + scm_minimum_tls_version                 = "1.2"
          + scm_type                                = (known after apply)
          + scm_use_main_ip_restriction             = false
          + use_32_bit_worker                       = true
          + vnet_route_all_enabled                  = false
          + websockets_enabled                      = false
          + worker_count                            = (known after apply)

          + application_stack {
              + docker_image_name = "ozouxapp2dev2025devacr.azurecr.io/wordpress-custom:v1"
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + webapp_url = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_service_plan.plan: Creating...
azurerm_service_plan.plan: Still creating... [00m10s elapsed]
azurerm_service_plan.plan: Still creating... [00m20s elapsed]
azurerm_service_plan.plan: Still creating... [00m30s elapsed]
azurerm_service_plan.plan: Still creating... [00m40s elapsed]
azurerm_service_plan.plan: Still creating... [00m50s elapsed]
azurerm_service_plan.plan: Still creating... [01m00s elapsed]
azurerm_service_plan.plan: Still creating... [01m10s elapsed]
azurerm_service_plan.plan: Still creating... [01m20s elapsed]
azurerm_service_plan.plan: Still creating... [01m30s elapsed]
azurerm_service_plan.plan: Still creating... [01m40s elapsed]
azurerm_service_plan.plan: Still creating... [01m50s elapsed]
azurerm_service_plan.plan: Still creating... [02m00s elapsed]
azurerm_service_plan.plan: Still creating... [02m10s elapsed]
azurerm_service_plan.plan: Still creating... [02m20s elapsed]
azurerm_service_plan.plan: Still creating... [02m30s elapsed]
azurerm_service_plan.plan: Still creating... [02m40s elapsed]
azurerm_service_plan.plan: Still creating... [02m50s elapsed]
azurerm_service_plan.plan: Still creating... [03m00s elapsed]
azurerm_service_plan.plan: Still creating... [03m10s elapsed]
azurerm_service_plan.plan: Still creating... [03m20s elapsed]
azurerm_service_plan.plan: Still creating... [03m30s elapsed]
azurerm_service_plan.plan: Still creating... [03m40s elapsed]
azurerm_service_plan.plan: Still creating... [03m50s elapsed]
azurerm_service_plan.plan: Still creating... [04m00s elapsed]
azurerm_service_plan.plan: Still creating... [04m10s elapsed]
azurerm_service_plan.plan: Still creating... [04m20s elapsed]
azurerm_service_plan.plan: Still creating... [04m30s elapsed]
azurerm_service_plan.plan: Still creating... [04m40s elapsed]
azurerm_service_plan.plan: Still creating... [04m50s elapsed]
azurerm_service_plan.plan: Still creating... [05m00s elapsed]
azurerm_service_plan.plan: Still creating... [05m10s elapsed]
azurerm_service_plan.plan: Still creating... [05m20s elapsed]
azurerm_service_plan.plan: Still creating... [05m30s elapsed]
azurerm_service_plan.plan: Still creating... [05m40s elapsed]
azurerm_service_plan.plan: Still creating... [05m51s elapsed]
azurerm_service_plan.plan: Still creating... [06m01s elapsed]
azurerm_service_plan.plan: Still creating... [06m11s elapsed]
ttled for subscription 5f13b879-49c5-44a1-8328-0b128ab8b9a2. Please contact support if issue persists.","Target":null,"Details":[{"Message":"App Service Plan Create operation is throttled for subscription 5f13b879-49c5-44a1-8328-0b128ab8b9a2. Please contact support if issue persists."},{"Code":"429"},{"ErrorEntity":{"ExtendedCode":"51025","MessageTemplate":"App Service Plan {0} operation is throttled for subscription {1}. Please contact support if issue persists.","Parameters":["Create","5f13b879-49c5-44a1-8328-0b128ab8b9a2"],"Code":"429","Message":"App Service Plan Create operation is throttled for subscription 5f13b879-49c5-44a1-8328-0b128ab8b9a2. Please contact support if issue persists."}}],"Innererror":null}
│
│   with azurerm_service_plan.plan,
│   on main.tf line 7, in resource "azurerm_service_plan" "plan":
│    7: resource "azurerm_service_plan" "plan" {
│
│ creating App Service Plan (Subscription: "5f13b879-49c5-44a1-8328-0b128ab8b9a2"
│ Resource Group Name: "ozoux-rg"
│ Server Farm Name: "ozouxapp2dev2025-dev-plan"): performing CreateOrUpdate: unexpected status 429 (429 Too Many Requests) with response: {"Code":"429","Message":"App Service Plan Create operation is throttled for subscription 5f13b879-49c5-44a1-8328-0b128ab8b9a2. Please contact support if issue
│ persists.","Target":null,"Details":[{"Message":"App Service Plan Create operation is throttled for subscription 5f13b879-49c5-44a1-8328-0b128ab8b9a2. Please contact support if issue persists."},{"Code":"429"},{"ErrorEntity":{"ExtendedCode":"51025","MessageTemplate":"App Service Plan {0} operation is    
│ throttled for subscription {1}. Please contact support if issue persists.","Parameters":["Create","5f13b879-49c5-44a1-8328-0b128ab8b9a2"],"Code":"429","Message":"App Service Plan Create operation is throttled for subscription 5f13b879-49c5-44a1-8328-0b128ab8b9a2. Please contact support if issue
│ persists."}}],"Innererror":null}
```


---

## 💬 Problèmes rencontrés

- **Terraform modules externes non accessibles** : remplacement par une déclaration directe du Resource Group.
- **Restriction sur le nom d’utilisateur MySQL** : Azure interdit `admin`, donc remplacé par `wpadmin`.
- **Problèmes de version MySQL** : `"8.0"` non autorisé, remplacé par `"8.0.21"`.
- **Gestion des identifiants sensibles** : évitée dans le code, placée dans les fichiers `.tfvars`.
- **Déployment de la configuration terraform envs\dev** : restriction de mon compte pour créer le service `azurerm_service_plan.plan`. 

---

## ✅ Améliorations possibles

- Ajouter une intégration CI/CD avec GitHub Actions.
- Utiliser un Key Vault pour sécuriser les mots de passe.
- Ajouter un module réseau avec un VNet privé.
- pouvoirdéployer la configue de terraform envs\dev. 

---

## 🔗 Auteur

- Nom : OZOUX Guillaume
- Date : Juin 2025
