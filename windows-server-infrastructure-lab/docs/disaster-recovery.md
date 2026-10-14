# Backup and recovery exercise

**Do not test AD restores in production.** Take VM snapshots for checkpoints, but do not treat a VM snapshot alone as an AD system-state backup.

## Lab process

1. In DC01, install `Windows-Server-Backup` and use a dedicated virtual backup disk (not the DC OS disk).
2. Perform Windows Server Backup **System State** backup using documented Windows Server Backup tooling. Example on a lab disk assigned `E:`:

   ```powershell
   Install-WindowsFeature Windows-Server-Backup
   wbadmin start systemstatebackup -backuptarget:E: -quiet
   wbadmin get versions -backuptarget:E:
   ```

3. Record version identifiers, date, backup target, and status. Protect the backup destination from normal user write access.
4. For recovery testing, create a **separate isolated clone** with no connectivity to the running domain controller. Follow the Microsoft-supported Active Directory system state recovery procedure suitable for your Windows Server version, including Directory Services Restore Mode (DSRM) and nonauthoritative versus authoritative recovery differences.
5. Verify directory objects and domain service health after the recovery; document downtime and any failures.

Avoid simply restoring DC snapshots into a live domain or attaching a recovered DC to an active lab network without understanding AD replication/USN implications.

## Recovery record

Date: NOT TESTED
Backup result: NOT TESTED
Restore result: NOT TESTED
RTO / RPO: NOT MEASURED
