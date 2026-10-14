# Deployment runbook

## Prepare the environment

Use a Windows hypervisor host with enough memory and disk for Windows Server 2022/2025 and Windows 11 Pro/Enterprise. Home edition cannot join this domain. Create an internal-only virtual switch and attach both VMs. Manage them through the hypervisor console.

Rename the server to `DC01` before promotion. Assign its isolated NIC `10.77.10.10/24`, without an uplink gateway. After promotion, point server and client DNS to `10.77.10.10`. Record the NIC name and switch mapping, and checkpoint the clean VMs. Copy the project folder to DC01.

## Provision the domain and identities

Run in elevated **Windows PowerShell 5.1** from `windows-server-infrastructure-lab`:

```powershell
.\scripts\01-Install-LabDomain.ps1 -Confirm
# Promotion restarts DC01. Sign in as CORP\Administrator afterward.
Get-ADDomain
Get-DnsServerZone
Resolve-DnsName dc01.corp.example.test
.\scripts\02-Initialize-Directory.ps1 -Confirm
.\scripts\03-Import-LabUsers.ps1 -CsvPath .\examples\users.example.csv -Confirm
```

The import validates all CSV rows before creating identities. It skips existing usernames; it does not reconcile their properties or group memberships. Accounts start disabled. For the client logon exercise, reset one test account to its own password, enable it, and keep password changes required at first logon:

```powershell
Set-ADAccountPassword lab.alex -Reset -NewPassword (Read-Host 'New test account password' -AsSecureString)
Enable-ADAccount lab.alex
Set-ADUser lab.alex -ChangePasswordAtLogon $true
```

## Configure DHCP

Confirm the isolated switch mapping before running:

```powershell
.\scripts\04-Configure-LabDhcp.ps1 -Confirm
Get-DhcpServerInDC
Get-DhcpServerv4Binding
Get-DhcpServerv4Scope
Get-DhcpServerv4OptionValue -ScopeId 10.77.10.0
```

The script authorizes the lab server in AD, binds DHCP to the selected lab NIC, disables other IPv4 DHCP bindings, and creates an inactive scope when absent. An existing scope retains its activation state; inspect it before rerunning. Domain Administrator permissions are required for authorization. The configured options supply the lab DNS server and domain; this network has no router option.

After confirming the scope and adapter configuration:

```powershell
Set-DhcpServerv4Scope -ScopeId 10.77.10.0 -State Active
```

## Join the client and apply policy

On CLIENT01, confirm DNS points to DC01, then run elevated Windows PowerShell:

```powershell
Add-Computer -DomainName corp.example.test -Credential (Get-Credential 'CORP\Administrator') -Restart
```

On DC01:

```powershell
Get-ADComputer CLIENT01 | Move-ADObject -TargetPath 'OU=LabWorkstations,DC=corp,DC=example,DC=test'
.\scripts\05-Set-BaselineGpo.ps1 -Confirm
.\scripts\06-Export-DirectoryAudit.ps1 -OutputPath .\evidence\directory-audit.csv
```

The GPO configures user screen-saver activation, password protection, and a 900-second timeout and links to **LabUsers**. It does not configure firewall or computer settings. Verify actual lock behavior on the selected Windows client; a configured screen saver may be needed for these settings to take effect.

Sign in to CLIENT01 as the enabled test user, complete the initial password change, and run `gpupdate /force` and `gpresult /r`. Complete [validation](validation.md) and store reviewed evidence in `evidence/sanitized/`.

## Teardown

Export reviewed evidence and backup records first. Power off and delete only the dedicated lab VMs, their virtual disks, and the dedicated switch using your hypervisor. Domain provisioning is a one-time operation; rebuild a clean VM for another forest exercise. This is a manual lab with scripted components.
