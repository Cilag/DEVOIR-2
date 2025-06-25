variable "app_name" {}
variable "environment" {}
variable "resource_group_name" {}
variable "location" {
  type    = string
  default = "westeurope"
}
variable "administrator_login" {}
variable "administrator_password" {}
