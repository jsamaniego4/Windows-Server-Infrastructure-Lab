#Requires -Version 5.1
[CmdletBinding()]
param([string]$OutputPath='.\evidence\directory-audit.csv')
$ErrorActionPreference='Stop'; Import-Module ActiveDirectory
$users=Get-ADUser -SearchBase "OU=LabUsers,$((Get-ADDomain).DistinguishedName)" -Filter * -Properties Enabled,Department,PasswordLastSet
$rows=@($users | Select-Object SamAccountName,Enabled,Department,PasswordLastSet)
$parent=Split-Path -Parent $OutputPath
if ($parent -and -not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
$rows | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($rows.Count) lab records. Review and sanitize before sharing."
