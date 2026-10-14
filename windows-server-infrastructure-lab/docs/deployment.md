# Deployment runbook

1. Provision isolated VMs; verify private virtual switch, assign DC01 static IPv4 `10.77.10.10/24` (DNS points to itself once promoted). Do not expose RDP/WinRM to public networks.
2. Snapshot the clean DC01 VM. Run domain install script elevated; reboot.
3. Confirm `Get-ADDomain`, `Get-DnsServerZone`, `Resolve-DnsName dc01.corp.example.test` (replace host if different).
4. Create OUs and groups, inspect CSV, import disabled lab users.
5. For DHCP, confirm with the VM hypervisor that the target network is internal only. Run DHCP script: scope stays inactive. Activate after inspection and document which NIC serves the scope.
6. Join CLIENT01 to domain and move its computer object into `OU=LabWorkstations`.
7. Configure the user-scoped GPO linked to LabUsers. Use `gpupdate /force` and `gpresult /r` from CLIENT01. User settings apply to test users in LabUsers.
8. Run directory audit and redact output before committing evidence.
9. Record deployment steps, dates, versions, commands and sanitized outputs.

This is a **manual lab** with scripted components, not a one-command unattended enterprise setup.
