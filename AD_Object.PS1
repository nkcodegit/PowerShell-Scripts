Get-ADComputer -Filter * -Property * | Select-Object Name,OperatingSystem,OperatingSystemVersion,ipv4Address | Export-CSV -Path c:\ADcomputerslist.csv -NoTypeInformation -Encoding UTF8

Import-Module DSInternals
$cred = Get-Credential
Get-ADReplAccount -SamAccountName April -Domain Adatum -Server LON-DC1 `
-Credential $cred -Protocol TCP
