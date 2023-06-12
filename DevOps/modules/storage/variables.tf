variable "storage_account_name" {
  type = string
  description = "This defines storage account name."
}

variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
}

variable "container_name" {
  type=string
  description = "This is container name"
}

variable "app_container_name" {
  type=string
  description = "This is container name for the application"
  default = "default"
}

variable "container_access" {
  type=string
  description = "This is container access level"
}

variable "blobs" {
  type=map
  description = "Defines blobs to be added"
  default = {""= ""}
}

variable "storage_account_exists" {
  type=bool
  description = "This defines if the storage account exists"
  default = false
}

variable "blobs_binary" {
  type=map
  description = "Defines binary blobs to be added"
  default = {""=""}
}

variable "blobs_enabled" {
  type=bool
  description = "This defines the blobs to be uploaded"
  default = false
}

variable "blobs_binary_enabled" {
  type=bool
  description = "This defines if the binary blobs need to be uploaded"
  default = false
}
