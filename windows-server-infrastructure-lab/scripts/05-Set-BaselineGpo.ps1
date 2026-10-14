#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
param([string]$DomainDN='DC=corp,DC=example,DC=test')
$ErrorActionPreference='Stop'
Import-Module ActiveDirectory
Import-Module GroupPolicy
if ((Get-ADDomain).DistinguishedName -ne $DomainDN) { throw 'Wrong lab domain' }
$name='Lab-Workstation-Baseline'
if (-not (Get-GPO -Name $name -ErrorAction SilentlyContinue)) {
 if ($PSCmdlet.ShouldProcess($name,'Create GPO')) { New-GPO -Name $name | Out-Null }
}
if ($PSCmdlet.ShouldProcess("OU=LabUsers,$DomainDN",'Link user GPO and configure screen lock')) {
 $links=(Get-GPInheritance -Target "OU=LabUsers,$DomainDN").GpoLinks
 if ($name -notin @($links | ForEach-Object DisplayName)) { New-GPLink -Name $name -Target "OU=LabUsers,$DomainDN" -LinkEnabled Yes | Out-Null }
 Set-GPRegistryValue -Name $name -Key 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop' -ValueName ScreenSaveActive -Type String -Value '1'
 Set-GPRegistryValue -Name $name -Key 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop' -ValueName ScreenSaverIsSecure -Type String -Value '1'
 Set-GPRegistryValue -Name $name -Key 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop' -ValueName ScreenSaveTimeOut -Type String -Value '900'
}
Write-Host 'This GPO applies user settings; verify intended user scope and gpresult. Not a complete security baseline.'
