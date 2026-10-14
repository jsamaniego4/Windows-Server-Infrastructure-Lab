# Validation and evidence

**Status:** Windows deployment, CI execution, and runtime checks are pending. Repository documentation and links were checked locally on macOS; PowerShell is unavailable there.

Record the date, Windows version, actual result, and sanitized artifact path for each check. Mark passed only after executing it.

| Check | Command or procedure | Expected result | Status |
| --- | --- | --- | --- |
| Static validation | `tests/Test-StaticValidation.ps1` on Windows | Six scripts parse; four selected analyzer rules pass | Pending |
| Forest | `Get-ADDomain` on DC01 | DNSRoot is `corp.example.test` | Pending |
| Directory structure | `Get-ADOrganizationalUnit -Filter *`; inspect LabGroups | Four lab OUs and three global security groups | Pending |
| Identity import | Inspect sample users; rerun import | Three disabled accounts initially; existing names skipped on rerun | Pending |
| Membership | `Get-ADGroupMember GG-Lab-IT` | `lab.alex` is a member | Pending |
| DNS | `Resolve-DnsName dc01.corp.example.test`; `Resolve-DnsName _ldap._tcp.dc._msdcs.corp.example.test -Type SRV` from client | DC A record and LDAP SRV records resolve | Pending |
| DHCP authorization | `Get-DhcpServerInDC`; `Get-DhcpServerv4Binding` | DC01 authorized; only isolated NIC bound | Pending |
| DHCP lease | `ipconfig /all` on CLIENT01; `Get-DhcpServerv4Lease -ScopeId 10.77.10.0` on DC01 | Client receives an address in `.100–.149` and DNS `.10` | Pending |
| Domain authentication | Log on with individually enabled test user | Domain logon succeeds after password change | Pending |
| User policy | `gpupdate /force`; `gpresult /h report.html` in test-user session | Lab GPO applies; verify lock after 900 seconds | Pending |
| Directory audit | Run script 06 and inspect CSV | Expected identity fields and account states | Pending |
| System-state backup | Follow recovery runbook | Successful backup and version identifier recorded | Pending |
| Recovery rehearsal | Restore in separate isolated environment | Directory objects and services verified; duration recorded | Pending |

## Result record

Copy for each executed check:

```text
Check:
Date:
Environment / OS version:
Command or procedure:
Expected result:
Actual result:
Status (passed / failed):
Sanitized artifact path:
Notes / incident link:
```

A policy report establishes policy applicability; it does not prove actual lock behavior. Static checks cannot establish live service health. Record failures and resolutions in the [incident template](incident-template.md), and backup/recovery results in the [recovery runbook](disaster-recovery.md).
