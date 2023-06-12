variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
}

variable "app_service_plan_name" {
  type        = string
  description = "App Service Plan name in Azure"
}

variable "app_service_name" {
  type        = string
  description = "App Service name in Azure"
}

variable "sql_server_name" {
  type        = string
  description = "SQL Server instance name in Azure"
}

variable "sql_database_name" {
  type        = string
  description = "SQL Database name in Azure"
}

variable "sql_admin_login" {
  type        = string
  description = "SQL Server login name in Azure"
}

variable "sql_admin_password" {
  type        = string
  description = "SQL Server password name in Azure"
}

variable "network_security_group_rules" {
  type=list
  description = "This defines the network security group rules"
}

variable "virtual_network_address_space" {
  type=string
  description="This defines the address of the virtual network"
}

variable "virtual_network_name" {
  type=string
  description="This defines the name of the virtual network"
}

variable subnet_names {
    type=set(string)
    description="This defines the subnets within the virtual network"
}

variable network-security_group_names {
    type=map(string)
    description="This defines the names of the network security groups"
}

variable "initialize_sql_script_execution" {
  description = "Allow/deny to Create and initialize a Microsoft SQL Server database"
  default     = true
}

variable "sqldb_init_script_file" {
  description = "SQL Script file name to create and initialize the database"
  default     = "dbscripts/01.sql"
}