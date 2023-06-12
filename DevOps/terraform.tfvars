resource_group_name     = "TerraformMiniProject-Matthew"
resource_group_location = "East US"
app_service_plan_name   = "mrappserviceplan2"
app_service_name        = "SQLmrwebapp35"
sql_server_name         = "mrsqlserver20"
sql_database_name       = "mrsqldatabase30"
sql_admin_login         = "azureuser"
sql_admin_password      = "MatthewR342"
network-security_group_names={
    "web-nsg"="web-subnet"
    "db-nsg"="db-subnet"}
network_security_group_rules=[{
      id=1,
      priority="200",
      network_security_group_name="web-nsg"
      destination_port_range="3389"
      access="Allow"
  },
  {
      id=2,
      priority="300",
      network_security_group_name="web-nsg"
      destination_port_range="80"
      access="Allow"
  },
  {
      id=3,
      priority="400",
      network_security_group_name="web-nsg"
      destination_port_range="8172"
      access="Allow"
  },
  {
      id=4,
      priority="200",
      network_security_group_name="db-nsg"
      destination_port_range="3389"
      access="Allow"
  }
  ]
subnet_names = ["web-subnet","db-subnet"]
virtual_network_name = "staging-network100"
virtual_network_address_space = "10.0.0.0/16"