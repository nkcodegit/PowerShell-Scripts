
  
<#Author   : Kugan
# Creation Date: 12-12-2019 
# Usage      : RPCCheck -Server YourServerNameHere
#**************************************************************************
# Date                     Version      Changes
#------------------------------------------------------------------------
# 12-12-2019                1.0       Intial Version
#***************************************************************************
#>

#  Script queries port 135 to get the listening ephemeral ports from the remote server
#  and verifies that they are reachable.  
#
#  Usage:  RPCCheck -Server YourServerNameHere
#
#  Note:  The script relies on portqry.exe (from Sysinternals) to get port 135 output.
#  The path to portqry.exe will need to be modified to reflect your location



Param(
  [string]$Server
)

#  WORKFLOW QUERIES THE PASSED ARRAY OF PORTS TO DETERMINE STATUS

workflow Check-Port {

  param ([string[]]$RPCServer,[array]$arrRPCPorts)

  $comp = hostname

 

  ForEach -parallel ($RPCPort in $arrRPCPorts)
  {

      $bolResult = InlineScript{Test-NetConnection -ComputerName $Using:RPCServer -port $Using:RPCPort -InformationLevel Quiet}

 If ($bolResult)
 {
      Write-Output "$RPCPort on $RPCServer is reachable"
 }
 Else
 {
     Write-Output "$RPCPort on $RPCServer is unreachable"
 }
}
}

#  INITIAL RPC PORT

$strRPCPort = "135"

#  MODIFY PATH TO THE PORTQRY BINARY IF NECESSARY
$strPortQryPath = "C:\PortQryV2\"

#  TEST THE PATH TO SEE IF THE BINARY EXISTS
If (Test-Path "$strPortQryPath\PortQry.exe")
{
  $strPortQryCmd = "$strPortQryPath\PortQry.exe -e $strRPCPort -n $Server"
}
Else
{
  Write-Output "Could not locate Portqry.exe at the path $strPortQryPath"
  Exit
}

#  CREATE AN EMPTY ARRAY TO HOLD THE PORTS RETURNED FROM THE RPC PORTMAPPER
$arrPorts = @()

#  RUN THE PORTQRY COMMAND TO GET THE EPHEMERAL PORTS

$arrQuryResult = Invoke-Expression $strPortQryCmd

# CREATE AN ARRAY OF THE PORTS
ForEach ($strResult in $arrQuryResult)
{
  If ($strResult.Contains("ip_tcp"))
  {
  $arrSplt = $strResult.Split("[")
  $strPort = $arrSplt[1]
  $strPort = $strPort.Replace("]","")
  $arrPorts += $strPort
  }
}

#  DE-DUPLICATE THE PORTS
$arrPorts = $arrPorts | Sort-Object |Select-Object -Unique

#  EXECUTE THE WORKFLOW TO CHECK THE PORTS
Check-Port -RPCServer $Server -arrRPCPorts $arrPorts
