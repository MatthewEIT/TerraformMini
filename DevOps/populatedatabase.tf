module "storage_module" {
  source = "./modules/storage"
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  storage_account_name = "miniprojectstorage342"
  container_name = "scripts"
  app_container_name = "images"
  blobs_enabled = true
  container_access = "blob"
blobs ={
    "01.sql"="./dbscripts/"
    "Script.ps1" = "./scripts/"
}
 # depends_on = [ main ]
}