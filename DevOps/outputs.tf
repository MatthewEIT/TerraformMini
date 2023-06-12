output "webapp_url" {
  value = azurerm_windows_web_app.SQLmrwebapp25.default_hostname
}

output "webapp_ips" {
  value = azurerm_windows_web_app.SQLmrwebapp25.outbound_ip_addresses
}