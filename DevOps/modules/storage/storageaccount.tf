resource "azurerm_storage_account" "storage" {
count = var.storage_account_exists ? 0 : 1
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}

resource "azurerm_storage_container" "container" {
    name = var.container_name
  storage_account_name =  var.storage_account_name
  container_access_type = var.container_access
  depends_on = [ azurerm_storage_account.storage
]
}

#data "template_file" "userdata" {
#  for_each=var.blobs
#  template=("${each.value}${each.key}")
#  vars = {
 #   storage_account_name = var.storage_account_name
 #   container_name = var.container_name
 #   app_container_name = var.app_container_name
 # }
#}
resource "azurerm_storage_blob" "blob" {
    for_each = {for k,v in var.blobs: k=> v if var.blobs_enabled}
  name = each.key
  storage_account_name = var.storage_account_name
  storage_container_name = var.container_name
  type = "Block"
  source_content = templatefile("${each.value}${each.key}",{storage_account_name = var.storage_account_name, container_name = var.container_name, app_container_name = var.app_container_name})
  depends_on = [ 
    azurerm_storage_container.container
   ]
}

resource "azurerm_storage_blob" "blob_binary" {
    for_each = {for k,v in var.blobs_binary: k=> v if var.blobs_binary_enabled}
  name = each.key
  storage_account_name = var.storage_account_name
  storage_container_name = var.container_name
  type = "Block"
  source = "${each.value}${each.key}"
  depends_on = [ 
    azurerm_storage_container.container
   ]
}