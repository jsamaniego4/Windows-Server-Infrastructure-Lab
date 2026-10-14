#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
param([string]$DomainDN='DC=corp,DC=example,DC=test')
$ErrorActionPreference='Stop'
Import-Module ActiveDirectory
$actual=(Get-ADDomain).DistinguishedName
if ($actual -ne $DomainDN) { throw "Domain mismatch; expected $DomainDN, found $actual" }
foreach ($ou in @('LabUsers','LabWorkstations','LabServers','LabGroups')) {
 $dn="OU=$ou,$DomainDN"
 if (-not (Get-ADOrganizationalUnit -LDAPFilter "(distinguishedName=$dn)" -ErrorAction SilentlyContinue)) {
  if ($PSCmdlet.ShouldProcess($dn,'Create OU')) { New-ADOrganizationalUnit -Name $ou -Path $DomainDN -ProtectedFromAccidentalDeletion $true }
 }
}
foreach ($group in @('GG-Lab-IT','GG-Lab-Engineering','GG-Lab-Finance')) {
 if (-not (Get-ADGroup -Filter "SamAccountName -eq '$group'" -ErrorAction SilentlyContinue)) {
  if ($PSCmdlet.ShouldProcess($group,'Create security group')) { New-ADGroup -Name $group -SamAccountName $group -GroupScope Global -GroupCategory Security -Path "OU=LabGroups,$DomainDN" }
 }
}
