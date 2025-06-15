# ----------------------------------------
# Windows User and Admin Scraper Script
# ----------------------------------------

# Export group members to files
Get-LocalGroupMember Administrators | Out-File admins.txt
Get-LocalGroupMember Users | Out-File users.txt

# Remove lines containing 'Group' from users.txt
Get-Content users.txt | Where-Object { $_ -notmatch 'Group' } | Set-Content users.txt

# Remove default 'Administrator' from admins.txt
Get-Content admins.txt | Where-Object { $_ -notmatch 'Administrator' } | Set-Content admins.txt

# Keep only lines with '\' (user accounts) in both files
Get-Content users.txt | Where-Object { $_ -match '\\' } | Set-Content users.txt
Get-Content admins.txt | Where-Object { $_ -match '\\' } | Set-Content admins.txt

# Extract user account names (remove domain prefix)
Select-String users.txt -Pattern '\\.*' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } | Out-File users_temp.txt
Select-String admins.txt -Pattern '\\.*' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value } | Out-File admins_temp.txt

# Remove 'Local' from account names
(Get-Content users_temp.txt -Raw) -replace 'Local','' | Set-Content users_temp.txt
(Get-Content admins_temp.txt -Raw) -replace 'Local','' | Set-Content admins_temp.txt

# Remove blank lines and trim whitespace
Get-Content admins_temp.txt | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() } | Out-File admins_main.txt
Get-Content users_temp.txt | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() } | Out-File users_main.txt

# Find users who are not admins
Compare-Object -ReferenceObject (Get-Content admins_main.txt | Sort-Object -Unique) `
               -DifferenceObject (Get-Content users_main.txt | Sort-Object -Unique) `
| Where-Object { $_.SideIndicator -eq '=>' } `
| Select-Object -ExpandProperty InputObject | Out-File nonadmins_main.txt

# Count users, admins, and non-admins
$users_count     = (Get-Content users_main.txt).Count
$admins_count    = (Get-Content admins_main.txt).Count
$nonadmins_count = (Get-Content nonadmins_main.txt).Count

# Read user lists
$users     = Get-Content users_main.txt
$admins    = Get-Content admins_main.txt
$nonadmins = Get-Content nonadmins_main.txt

# Output formatting variables
$separator = "-----------------------------------------------"
$title = "Scrape for Windows: "
$empty_line = ""

# Write results to output.txt
$title        | Set-Content    output.txt
$separator    | Add-Content    output.txt
$empty_line   | Add-Content    output.txt
"Total number of users: $users_count" | Add-Content output.txt
$empty_line   | Add-Content    output.txt
"List of all users:" | Add-Content output.txt
$users        | Add-Content    output.txt
$empty_line   | Add-Content    output.txt
$separator    | Add-Content    output.txt
$empty_line   | Add-Content    output.txt
"Number of Admin users: $admins_count" | Add-Content output.txt
$empty_line   | Add-Content    output.txt
"List of Admin users:" | Add-Content output.txt
$admins       | Add-Content    output.txt
$empty_line   | Add-Content    output.txt
$separator    | Add-Content    output.txt
$empty_line   | Add-Content    output.txt
"Number of Non-Admin users: $nonadmins_count" | Add-Content output.txt
$empty_line   | Add-Content    output.txt
"List of Non-Admin users:" | Add-Content output.txt
$nonadmins    | Add-Content    output.txt
$empty_line   | Add-Content    output.txt
$separator    | Add-Content    output.txt

# Clean up temporary files
Remove-Item admins.txt, users.txt, admins_temp.txt, users_temp.txt, users_main.txt, admins_main.txt, nonadmins_main.txt -ErrorAction SilentlyContinue