#Requires -RunAsAdministrator
#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
param([ValidatePattern('^[a-z0-9-]+(\.[a-z0-9-]+)+$')][string]$DomainName='corp.example.test')
$ErrorActionPreference='Stop'
if ($DomainName -ne 'corp.example.test') { throw 'This starter kit permits only the default fictional lab domain.' }
if (Get-Command Get-ADDomain -ErrorAction SilentlyContinue) {
 try { $existing=Get-ADDomain -ErrorAction Stop; throw "This machine is already in an AD domain: $($existing.DNSRoot). Use a fresh lab VM." } catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] { }
}
Write-Warning 'This script installs AD DS, creates a new forest, and restarts the server. Run only in an isolated disposable VM.'
if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME,"Install AD DS/DNS and create forest $DomainName")) {
 Install-WindowsFeature AD-Domain-Services,DNS -IncludeManagementTools | Out-Null
 Import-Module ADDSDeployment
 $safe = Read-Host 'Enter Directory Services Restore Mode password' -AsSecureString
 Install-ADDSForest -DomainName $DomainName -DomainNetbiosName 'CORP' -InstallDNS -SafeModeAdministratorPassword $safe -Force:$false
}
