# Deployment evidence (not yet collected)

Save **sanitized** evidence after executing the lab: VM console showing hostnames and roles; directory OUs/groups; DNS lookups; DHCP leases; gpresult; redacted audit summary; Windows Server Backup logs; restore rehearsal; scripted command output.

Do not publish passwords, tokens, IPs belonging to real organizations, real identities, or domain/OS secrets. Never fabricate test results. Recommended naming: `01-domain-installed.png`, `02-dns-lookup.png`, etc.

## Publication workflow

Raw files in this folder are ignored by Git. Copy only reviewed, sanitized outputs to `sanitized/`, which is permitted by the repository ignore rules. Reference each published artifact from the validation record with its date and observed result. Do not add placeholder screenshots or sample outputs labeled as execution evidence.

| Artifact | Supports | Status |
| --- | --- | --- |
| Domain and OU console capture | Forest and directory structure | Pending |
| DNS queries and client lease | DNS and DHCP runtime checks | Pending |
| User policy report and lock observation | GPO application and behavior | Pending |
| Reviewed directory audit | Identity and account state checks | Pending |
| Backup log and recovery record | Backup and restore exercise | Pending |
| Successful Actions run link | Static validation | Pending |
