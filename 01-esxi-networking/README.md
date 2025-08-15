# 01 — ESXi Networking

**Goal:** Create an **isolated** lab network for AD + clients.

## Steps
1. **Create Port Group**
   - vSwitch: `vSwitch0` (or create a new vSwitch)
   - Port Group: `LabNet`
   - VLAN ID: 0 (none)
   - Security: default

   📸 Screenshot: *ESXi Port Group LabNet created*

2. **Plan IPs**
   - DC01  : `192.168.56.10/24`
   - WIN11 : `192.168.56.20/24`
   - RHEL9 : `192.168.56.30/24`
   - Gateway: none (isolated lab) or a NAT VM if you need Internet

3. **Create VMs**
   - **DC01**: Windows Server 2022, 2 vCPU, 4–8 GB RAM, 60 GB disk
   - **WIN11**: Windows 11 Pro, 2 vCPU, 4–8 GB RAM
   - **RHEL9**: Rocky/RHEL 9 Minimal, 2 vCPU, 2–4 GB RAM

   📸 Screenshot: *VM inventory showing DC01, WIN11, RHEL9 attached to LabNet*
