$information = @"
---------------------------------------------------------
      ===== Export_Machines_and_convert_to_IP =====

Author:: Jose Manuel Mendez
Copyright:: Copyright (c) 2024
All rights of use reserved. It is not allowed
to copy or use this script without explicit permission

# Note: You will need to replace de value of "Domain"
variable according to your domain.
Also you will need to replace "SearchBase" variable 
value according to the OU you want to search for.

---------------------------------------------------------

"@


Clear-Host
Write-Host $information

$Domain = "<domain.com>"  # Change acording to your domain
$LogonServer = $env:LOGONSERVER -replace '\\\\', ''
$DC = $LogonServer + "." + $Domain
$date = (Get-Date).ToString("yyyyMMdd")
$path = "C:\Temp\"


$SearchBase_Type0 = "OU=subtree0,OU=Tree0,DC=domain,DC=com"
$SearchBase_Type1 = "OU=subtree1,OU=Tree1,DC=domain,DC=com"
$OutputFile_Type0 = $path + $date + "_machines_Type0.csv"
$OutputFile_Type1 = $path + $date + "_machines_Type1.csv"
$OutputFile_Type1 = "C:\Temp\machines_Type1.csv"

New-Item -ItemType File -Path $OutputFile_Type0 -Force > $null
New-Item -ItemType File -Path $OutputFile_Type1 -Force > $null

$names_Type0 = Get-ADComputer -Server $DC -Filter * -SearchBase $SearchBase_Type0 | Select-Object  Name 
foreach ($name in $names_Type0) {
    $name.Name = $name.Name + "." + $Domain
    $ip = (Resolve-DnsName -Name $name.Name).IPAddress
    $name | Add-Member -NotePropertyName IPAddress -NotePropertyValue $ip
}
$names_Type0 | Export-Csv $OutputFile_Type0 -Encoding UTF8 -delimiter '|' -NoTypeInformation

$names_Type1 = Get-ADComputer -Server $DC -Filter * -SearchBase $SearchBase_Type1 | Select-Object  Name 
foreach ($name in $names_Type1) {
    $name.Name = $name.Name + "." + $Domain
    $ip = (Resolve-DnsName -Name $name.Name).IPAddress
    $name | Add-Member -NotePropertyName IPAddress -NotePropertyValue $ip
}
$names_Type1 | Export-Csv $OutputFile_Type1 -Encoding UTF8 -delimiter '|' -NoTypeInformation



# Ask the user if they want to perform a search at the end
$search = Read-Host "Do you want to search in the names? (Y/N)" 

if ($search -match "^[Yy]") {
    $textSearch = Read-Host "Enter the text to search in the names"
    $names_Type0 | Where-Object { $_.Name -like "*$textSearch*" } | ForEach-Object { Write-host ($_.Name + "`n`tMachine Type 0 `n`tAD Route : " + $SearchBase_Type0)}
    $names_Type1 | Where-Object { $_.Name -like "*$textSearch*" } | ForEach-Object { Write-Host ($_.Name + "`n`tMachine Type 1 `n`tAD Route : " + $SearchBase_Type1)}
} else {
    Write-Host "`nGoodbye!"
}
