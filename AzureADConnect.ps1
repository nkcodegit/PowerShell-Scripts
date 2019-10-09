  
<#Author       : Kugan
# Creation Date: 10-09-2019
# Usage        : Azure AD Connect
#********************************************************************************
# Date                         Version      Changes
#------------------------------------------------------------------------
# 10-09-2019                    1.0        Intial Version
#
#
#*********************************************************************************
#
#>


####################################
#    Install PowerShell Modules    #
####################################
Find-Module -Name AzureAD | Install-Module -Force -AllowClobber -Verbose
Find-Module -Name AZ | Install-Module -Force -AllowClobber -Verbose
Find-Module -Name AzureRM | Install-Module -Force -AllowClobber -Verbose
Find-Module -Name MSonline | Install-Module -Force -AllowClobber -Verbose



################################
#    Authenticate to Azure     #
################################
$Admin = 'admin@nkcode.xyz'
$creds = Get-Credential `
    -UserName $Admin `
    -Message "Enter Password for Azure Credentials"

Login-AzAccount -Credential $creds
#Login-AzAccount -Credential $creds
Connect-AzureAD -Credential $creds
connect-msolservice -credential $creds


###################################
#    Azure AD Connect Commands    #
###################################
Import-Module ADSync
Start-ADSyncSyncCycle -PolicyType Initial
Start-ADSyncSyncCycle -PolicyType Delta
