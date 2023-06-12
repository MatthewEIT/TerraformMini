$LoginName="azureuser"
$LoginPassword="MatthewR342"
$DatabaseName="mrsqldatabase"
$ServerName="mrsqlserver"
$DBQuery="CREATE DATABASE mrsqldatabase"


Invoke-SqlCmd -ServerInstance $ServerName -U $LoginName -p $LoginPassword -Query $DBQuery



$LoginName="azureuser"
$LoginPassword="MatthewR342"
$DatabaseName="mrsqldatabase"
$ServerName="mrsqlserver"
$ScriptFile="https://${storage_account_name}.blob.core.windows.net/${container_name}/01.sql"
$Destination="D:\01.sql"


Invoke-WebRequest -Uri $ScriptFile -OutFile $Destination
Invoke-SqlCmd -ServerInstance $ServerName -InputFile $Destination -Database $DatabaseName -Username $LoginName -Password $LoginPassword
#Invoke-Sqlcmd -Database $DatabaseName -Query "exec dbo.Products N'$(Get-Content "D:\01.sql")'"

