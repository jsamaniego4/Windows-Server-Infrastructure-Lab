#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Medium')]
param([Parameter(Mandatory)][string]$CsvPath,[string]$DomainDN='DC=corp,DC=example,DC=test')
$ErrorActionPreference='Stop'
Import-Module ActiveDirectory
if ((Get-ADDomain).DistinguishedName -ne $DomainDN) { throw 'Wrong lab domain' }
$rows=@(Import-Csv -LiteralPath $CsvPath)
if ($rows.Count -eq 0) { throw 'CSV is empty' }
$groups=@('IT','Engineering','Finance')
$names=@{}
foreach ($u in $rows) {
 if (-not $u.SamAccountName -or $u.SamAccountName -notmatch '^[a-z][a-z0-9._-]{2,19}$') { throw "Invalid username: $($u.SamAccountName)" }
 if ($names.ContainsKey($u.SamAccountName)) { throw "Duplicate username $($u.SamAccountName)" }
 $names[$u.SamAccountName]=$true
 if ($u.Department -notin $groups) { throw "Unsupported department: $($u.Department)" }
 if (-not $u.GivenName -or -not $u.Surname) { throw 'Missing name columns' }
}
# Password is never committed or echoed. Accounts remain disabled pending individual password reset and approval.
$pwd=Read-Host 'Enter strong TEMPORARY password for disabled lab users' -AsSecureString
foreach ($u in $rows) {
 $name=$u.SamAccountName
 if (Get-ADUser -Filter "SamAccountName -eq '$name'" -ErrorAction SilentlyContinue) { Write-Warning "Skipping existing user $name"; continue }
 if ($PSCmdlet.ShouldProcess($name,'Create disabled lab user')) {
  New-ADUser -Name "$($u.GivenName) $($u.Surname)" -GivenName $u.GivenName -Surname $u.Surname -SamAccountName $name -UserPrincipalName "$name@corp.example.test" -Department $u.Department -Path "OU=LabUsers,$DomainDN" -AccountPassword $pwd -Enabled $false -ChangePasswordAtLogon $true
  Add-ADGroupMember -Identity "GG-Lab-$($u.Department)" -Members $name
 }
}
