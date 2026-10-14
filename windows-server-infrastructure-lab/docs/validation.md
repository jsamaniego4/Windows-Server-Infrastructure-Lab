# Validation checklist (fill in after lab execution)

- [ ] `Get-ADDomain` returns `corp.example.test`
- [ ] DNS A / SRV queries resolve correctly from domain client
- [ ] DHCP lease assigned to CLIENT01 on the **isolated** virtual switch
- [ ] Domain logon for individually enabled test user works
- [ ] `Get-ADGroupMember GG-Lab-IT` lists intended lab user
- [ ] `gpresult /h report.html` shows applicable workstation policies (adjust GPO scope if needed)
- [ ] Audit CSV generated and sanitized
- [ ] Domain controller system state backup completed and logged
- [ ] Restore rehearsal in separate isolated VM environment documented

Evidence columns: check / date / environment / command / expected result / actual result / screenshot path / notes.
