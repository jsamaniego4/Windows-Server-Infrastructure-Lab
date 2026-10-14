# Windows Server Infrastructure & Active Directory Automation Lab

[Portfolio overview](../README.md) · [Deployment](docs/deployment.md) · [Validation](docs/validation.md) · [Resume entry](docs/resume.md)

A reproducible, **self-directed** systems administration lab for demonstrating Windows Server, AD DS, DNS, DHCP, Group Policy, PowerShell automation, and disaster-recovery planning.

> **Status: lab kit / not deployed.** The repository contains provisioning scripts and operational runbooks. Do not claim domain deployment, backups, or recovery tests until you perform and document them. Everything runs only in a personally owned, isolated VM lab.

## What this project demonstrates

- Domain controller provisioning for a fictional company (`corp.example.test`), with integrated DNS
- DHCP configuration for an isolated, **internal-only** virtual network
- Organizational Units, security groups, bulk user provisioning from CSV, and permission auditing
- A scoped GPO starter baseline (user screen-lock settings)
- Backup / restore testing plan and operational runbooks
- CI checks for PowerShell syntax and PSScriptAnalyzer linting

## Architecture

![Lab architecture](docs/architecture.svg)

| Host | OS / Role | Address (example only) |
| --- | --- | --- |
| DC01 | Windows Server 2022/2025 evaluation, AD DS / DNS / DHCP | 10.77.10.10 |
| CLIENT01 | Windows 11 Pro/Enterprise evaluation, domain joined | DHCP: 10.77.10.100–149 |
| Lab virtual switch | Hyper-V **internal** switch | 10.77.10.0/24 |

The examples use an isolated IPv4 subnet. **Never run DHCP setup on a corporate, shared, bridged, or home production LAN.** The scripts check the default lab prefix and require opt-in for server provisioning.

## Prerequisites

1. An isolated VM hypervisor (Hyper-V on supported Windows, or an equivalent); two evaluation VMs; adequate RAM / disk.
2. Local Administrator rights on the new lab Windows Server VM.
3. Windows PowerShell 5.1 for provisioning and validation on Windows; server role and GroupPolicy cmdlets require Windows.
4. Take VM snapshots/checkpoints before making changes. Set a dedicated lab-only administrator password, and keep it out of the repository.

## Quick start (review every script first)

1. Configure a private virtual switch and static IP `10.77.10.10/24` on the server. Do not expose the server or DHCP to a real network.
2. On DC01 in elevated Windows PowerShell 5.1, install AD DS and DNS, then create the lab forest (reboot required):

   ```powershell
   .\scripts\01-Install-LabDomain.ps1 -DomainName 'corp.example.test' -Confirm
   ```

3. After reboot, sign in as the lab domain administrator and create organizational units/groups:

   ```powershell
   .\scripts\02-Initialize-Directory.ps1 -DomainDN 'DC=corp,DC=example,DC=test' -Confirm
   ```

4. Review CSV entries in `examples/users.example.csv`. Supply a temporary starter password interactively and create users (accounts are disabled by default):

   ```powershell
   .\scripts\03-Import-LabUsers.ps1 -CsvPath .\examples\users.example.csv -DomainDN 'DC=corp,DC=example,DC=test' -Confirm
   ```

5. Optionally set up DHCP **only after verifying the isolated NIC**:

   ```powershell
   .\scripts\04-Configure-LabDhcp.ps1 -ServerIp 10.77.10.10 -ScopeStart 10.77.10.100 -ScopeEnd 10.77.10.149 -Confirm
   ```

6. Create a baseline GPO and link it to the lab users OU:

   ```powershell
   .\scripts\05-Set-BaselineGpo.ps1 -DomainDN 'DC=corp,DC=example,DC=test' -Confirm
   ```

7. Export a sanitized directory audit and verify identities:

   ```powershell
   .\scripts\06-Export-DirectoryAudit.ps1 -OutputPath .\evidence\directory-audit.csv
   ```

8. Join CLIENT01 to the domain, confirm DNS resolution and group policy application; follow `docs/validation.md`.

**Notes:** Domain creation restarts the VM; DHCP and GPO settings are lab examples, not enterprise security standards. Forest provisioning is a one-time operation. The audit may contain user identities, so treat exports as private and only publish sanitized/sample outputs.

## Engineering evidence

Add **your own** screenshots and redacted logs under `evidence/` after building. The repository deliberately includes no fabricated deployment screenshots or passing lab results. See `evidence/README.md`.

## Operational guides

- [Architecture / assumptions](docs/architecture.md)
- [Deployment runbook](docs/deployment.md)
- [Validation checklist](docs/validation.md)
- [Backup and recovery exercise](docs/disaster-recovery.md)
- [Troubleshooting notes template](docs/incident-template.md)

## Portfolio and validation

See [resume wording](docs/resume.md) for descriptions of current deliverables and completed-lab wording. Run [static validation](tests/README.md) before publishing changes; record live results separately in the [validation checklist](docs/validation.md).

Keep credentials, real identities, domain secrets, and raw audit exports out of Git. Place reviewed artifacts in `evidence/sanitized/`; raw evidence is ignored by default.

## License
MIT.
