#Requires -RunAsAdministrator
#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
param([string]$ServerIp='10.77.10.10',[string]$ScopeStart='10.77.10.100',[string]$ScopeEnd='10.77.10.149')
$ErrorActionPreference='Stop'
if ($ServerIp -ne '10.77.10.10' -or $ScopeStart -ne '10.77.10.100' -or $ScopeEnd -ne '10.77.10.149') { throw 'Only the documented isolated lab subnet and DHCP range are supported.' }
$ips=@(Get-NetIPAddress -AddressFamily IPv4 | Where-Object IPAddress -eq $ServerIp)
if ($ips.Count -ne 1) { throw 'Expected lab static IP was not found on exactly one local NIC.' }
$nic=Get-NetAdapter -InterfaceIndex $ips[0].InterfaceIndex
Write-Warning "VERIFY physical isolation of adapter '$($nic.Name)'! The IP check alone CANNOT prove network isolation. DHCP on a shared network can disrupt connectivity."
if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME,'Install and authorize isolated lab DHCP scope')) {
 Install-WindowsFeature DHCP -IncludeManagementTools | Out-Null
 Import-Module DhcpServer
 if (-not (Get-DhcpServerv4Scope -ScopeId 10.77.10.0 -ErrorAction SilentlyContinue)) { Add-DhcpServerv4Scope -Name 'Internal-Lab-Only' -StartRange $ScopeStart -EndRange $ScopeEnd -SubnetMask 255.255.255.0 -State InActive }
 Set-DhcpServerv4OptionValue -ScopeId 10.77.10.0 -DnsServer $ServerIp -DnsDomain 'corp.example.test'
 Write-Host 'DHCP scope CREATED INACTIVE. After confirming private switch isolation, activate manually with Set-DhcpServerv4Scope -ScopeId 10.77.10.0 -State Active.'
}
