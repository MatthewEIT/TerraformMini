resource "azurerm_virtual_network" "network" {
  name                = var.virtual_network_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = [var.virtual_network_address_space]
  depends_on = [
    azurerm_resource_group.TerraformMiniProject-Matthew
  ]  
} 
resource "azurerm_subnet" "subnets" {  
    for_each=var.subnet_names  
    name                 = each.key
    resource_group_name  = var.resource_group_name
    virtual_network_name = var.virtual_network_name
    address_prefixes     = [cidrsubnet(var.virtual_network_address_space,8,index(tolist(var.subnet_names),each.key))]
    service_endpoints = ["Microsoft.Sql"]

    delegation {
        name = "vnet-delegation"

        service_delegation {
            name = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
    }
    depends_on = [
      azurerm_virtual_network.network
    ]
}

resource "azurerm_network_security_group" "nsg" {
  for_each=var.network-security_group_names
  name                = each.key
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_virtual_network.network
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg-link" {  
  for_each=var.network-security_group_names
  subnet_id                 = azurerm_subnet.subnets[each.value].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id

  depends_on = [
    azurerm_virtual_network.network,
    azurerm_network_security_group.nsg
  ]
}

resource "azurerm_network_security_rule" "nsgrules" {
  for_each={for rule in var.network_security_group_rules:rule.id=>rule}
  name                        = "${each.value.access}-${each.value.destination_port_range}"
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = each.value.access
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.network_security_group_name].name
  depends_on = [
   azurerm_network_security_group.nsg
 ]
}

resource "azurerm_resource_group" "TerraformMiniProject-Matthew" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = "Development"
  }
}

resource "azurerm_service_plan" "mrappserviceplan2" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.TerraformMiniProject-Matthew.name
  location            = azurerm_resource_group.TerraformMiniProject-Matthew.location
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "SQLmrwebapp35" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.TerraformMiniProject-Matthew.name
  location            = azurerm_service_plan.mrappserviceplan2.location
  service_plan_id     = azurerm_service_plan.mrappserviceplan2.id

  site_config {
     always_on = false
     application_stack {
       current_stack = "dotnet"
     dotnet_version = "v6.0"
}
  }
  depends_on = [ 
    azurerm_service_plan.mrappserviceplan2
    ]
  //app_settings = {
    //"SOME_KEY" = "some-value"
  //}
  connection_string {
    name  = "Database"
    type  = "SQLAzure"
    value = "Server=tcp:azurerm_mssql_server.mrsqlserver.fully_qualified_domain_name Database=azurerm_mssql_database.mrsqldatabase.name;User ID=azurerm_mssql_server.mrsqlserver.administrator_login;Password=azurerm_mssql_server.mrsqlserver.administrator_login_password;Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_mssql_server" "mrsqlserver20" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.TerraformMiniProject-Matthew.name
  location                     = azurerm_resource_group.TerraformMiniProject-Matthew.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  public_network_access_enabled = true
}


resource "azurerm_mssql_database" "mrsqldatabase30" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.mrsqlserver20.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb = 5
  sku_name       = "Basic"
  zone_redundant = false
  depends_on = [ 
     azurerm_mssql_server.mrsqlserver20
    ]
}

resource "azurerm_mssql_firewall_rule" "sqlfirewall1" {
   for_each         = toset(azurerm_linux_web_app.api_app.outbound_ip_address_list)
   name             = "FirewallRule"
   server_id        = azurerm_mssql_server.mrsqlserver20.id
   start_ip_address = each.key
   end_ip_address   = each.key
   depends_on = [
     azurerm_mssql_database.mrsqldatabase30,
     azurerm_sssql_server.mrsqlserver20,
     azurerm_service_plan.mrappserviceplan2,
     azurerm_windows_web_app.SQLmrwebapp35
   ]
}

resource "null_resource" "create_sql" {
  count = var.initialize_sql_script_execution ? 1 : 0
  provisioner "local-exec" {
    command = "sqlcmd -I -U ${azurerm_mssql_server.mrsqlserver.administrator_login} -P ${azurerm_mssql_server.mrsqlserver.administrator_login_password} -S ${azurerm_mssql_server.mrsqlserver.fully_qualified_domain_name} -d ${azurerm_mssql_database.mrsqldatabase.name} -i ${var.sqldb_init_script_file} -o ${format("%s.log", replace(var.sqldb_init_script_file, "/.sql/", ""))}"
  }
  depends_on = [ 
    module.storage_module,
    azurerm_mssql_database.mrsqldatabase30
   ]
}

resource "azurerm_mssql_virtual_network_rule" "db" {
  
  name      = var.virtual_network_name
  server_id = azurerm_mssql_server.mrsqlserver20.id
  subnet_id = azurerm_subnet.subnets["db-subnet"].id
  depends_on = [ 
    azurerm_virtual_network.network
   ]
}

#resource "azurerm_mssql_database_extended_auditing_policy" "policy" {
#  database_id                             = azurerm_mssql_database.mrsqldatabase.id
#  storage_endpoint                        = azurerm_storage_account.storage.primary_blob_endpoint
#  storage_account_access_key              = azurerm_storage_account.storage.primary_access_key
#  storage_account_access_key_is_secondary = false
#  retention_in_days                       = 1
#}

