module "app_storage_module" {
  source = "./modules/storage"
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
  storage_account_name = "miniprojectstorage342"
  container_name = "images"
  container_access = "blob"
  storage_account_exists = true
  blobs_binary_enabled = true
  blobs_binary ={
    "Laptop.jpg"="./images/"
    "Mobile.jpg" = "./images/"
    "Tab.jpg"="./images/"
}
 # depends_on = [ main ]
}

