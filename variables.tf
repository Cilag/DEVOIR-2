variable "app_name" {}
variable "environment" {}
variable "location" {}
variable "mysql_admin" {}
variable "mysql_password" {}
variable "subscription_id" {
  type        = string
  description = "ID de la souscription Azure à utiliser"
}
