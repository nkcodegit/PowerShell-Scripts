#region Prerequisites and Azure Login

# Connect to Azure (opens browser for Azure Portal authentication)
Connect-AzAccount

# (Optional) Select a specific subscription if you have more than one
# Get-AzSubscription
# Set-AzContext -SubscriptionId "<SUBSCRIPTION-ID>"

# Verify Az.Network module is installed
$azNetwork = Get-InstalledModule -Name Az.Network -ErrorAction SilentlyContinue

if (-not $azNetwork) {
    Install-Module -Name Az.Network -AllowClobber -Force
}

#endregion

#region Create Resource Group

New-AzResourceGroup `
    -Name "SubnetDemoRG" `
    -Location "WestUS"

#endregion

#region Create VNet with Single Subnet

# Define subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
    -Name "demosubnet" `
    -AddressPrefix "10.50.1.0/24"

# Create virtual network
New-AzVirtualNetwork `
    -ResourceGroupName "SubnetDemoRG" `
    -Location "WestUS" `
    -Name "vnet-demo-subnet" `
    -AddressPrefix "10.50.0.0/16" `
    -Subnet $subnetConfig

#endregion

#region Example 1 - Add Multiple Prefixes to Existing Subnet

# Get existing VNet
$vnet = Get-AzVirtualNetwork `
    -ResourceGroupName "SubnetDemoRG" `
    -Name "vnet-demo-subnet"

# View existing subnets
$vnet.Subnets

# Update subnet with multiple prefixes
Set-AzVirtualNetworkSubnetConfig `
    -VirtualNetwork $vnet `
    -Name "demosubnet" `
    -AddressPrefix "10.50.1.0/24", "10.50.2.0/24"

# Apply changes to VNet
$vnet | Set-AzVirtualNetwork

# Verify changes
(Get-AzVirtualNetwork -ResourceGroupName "SubnetDemoRG" -Name "vnet-demo-subnet").Subnets

#endregion

#region Example 2 - New VNet with Multi-Prefix Subnet

# Create subnet with multiple prefixes
$multiSubnetConfig = New-AzVirtualNetworkSubnetConfig `
    -Name "multisubnet" `
    -AddressPrefix "10.110.2.0/24", "10.210.2.0/24"

# Create new VNet with multiple address spaces
New-AzVirtualNetwork `
    -ResourceGroupName "SubnetDemoRG" `
    -Location "WestUS" `
    -Name "multi-vnet" `
    -AddressPrefix "10.110.0.0/16", "10.210.0.0/16" `
    -Subnet $multiSubnetConfig

# View subnets
(Get-AzVirtualNetwork -ResourceGroupName "SubnetDemoRG" -Name "multi-vnet").Subnets

#endregion

#region Example 3 - Remove Prefix from Subnet

# Get existing VNet
$vnet = Get-AzVirtualNetwork `
    -ResourceGroupName "SubnetDemoRG" `
    -Name "vnet-demo-subnet"

# View current subnet configuration
$vnet.Subnets

# Remove second prefix by redefining subnet
Set-AzVirtualNetworkSubnetConfig `
    -VirtualNetwork $vnet `
    -Name "demosubnet" `
    -AddressPrefix "10.50.1.0/24"

# Apply changes
$vnet | Set-AzVirtualNetwork

# Verify result
(Get-AzVirtualNetwork -ResourceGroupName "SubnetDemoRG" -Name "vnet-demo-subnet").Subnets

#endregion




