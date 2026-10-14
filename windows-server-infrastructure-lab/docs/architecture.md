# Architecture and assumptions

Two virtual machines share a private, internal-only Hyper-V virtual switch. DC01 provides AD DS and DNS; optionally DHCP. CLIENT01 consumes DNS and DHCP and joins `corp.example.test`. Management is via VM console / local hypervisor access.

**Trust boundary:** this lab is not connected to any corporate environment. Avoid bridged network adapters when DHCP is enabled. If Internet access is needed temporarily for updates, use a separate NAT network that cannot serve DHCP to the uplink. Verify routes and adapter mapping before activating a DHCP scope.

Threats considered: DHCP leakage into a real LAN, weak lab passwords, credentials in Git, unredacted audit exports, overly broad privileged access. Controls: inactive-by-default DHCP, scoped examples, prompt-only passwords, sanitized evidence, no public remote management.
