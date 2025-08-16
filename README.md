# Windows & Linux Hybrid Admin Lab — Full Walkthrough

[![Lab Status](https://img.shields.io/badge/Lab-In_Progress-blue)](#)
[![Windows](https://img.shields.io/badge/Windows-Server_2022-0078D6?logo=windows)](#)
[![Linux](https://img.shields.io/badge/Linux-RHEL%2FRocky_9-FCC624?logo=linux)](#)
[![Active Directory](https://img.shields.io/badge/Active%20Directory-Enabled-003366)](#)



## Table of Contents
- [Step 1 — ESXi/vSphere Networking](#step-1--esxivsphere-networking-isolated-lab)
- [Step 2 — Windows Domain Controller](#step-2--windows-domain-controller-ad-ds--dns--gpo)
  - [GPO Settings Reference](#gpo-settings-reference-inline)
- [Step 3 — Windows Client Join](#step-3--windows-client-join-win11)
- [Step 4 — Linux Domain Join](#step-4--linux-domain-join-rhelrocky-9-with-realmdsssd)
- [Step 5 — Security Baselines](#step-5--security-baselines)
  - [Linux OpenSCAP Notes](#linux-openscap-notes)
- [Step 6 — Validation & Evidence](#step-6--validation--evidence)
- [Architecture](#architecture-for-reference)
- [Repo Pointers](#repo-pointers)
- [Execution Checklist](#execution-checklist)

This single README is the **start-to-finish guide**. Follow it top to bottom and drop screenshots where indicated.

**Goal:** Build a small, realistic enterprise lab that proves cross‑platform administration:
- Windows Server **Active Directory** + DNS + GPO
- A Windows 10/11 domain client
- A **Rocky/RHEL 9** Linux server joined to AD with **SSSD/realmd**
- Security baselines: password policy, banners, audit, and **OpenSCAP** scan on Linux
- Group‑based **sudo** for AD group `Linux_Admins`
- Step‑by‑step docs with **screenshots placeholders** and validation scripts


## Step 1 — ESXi/vSphere Networking (Isolated Lab)

**Goal:** Create an **isolated** lab network for AD + clients.

### Steps
1. **Create Standard vSwitch (isolated)**
   - Host & Clusters → Select ESXi host → **Configure → Networking → Virtual switches → Add standard virtual switch**
   - Name: `vSwitch-Lab`, Uplinks: **0** (isolated), MTU: default
   - Create

   📸 Screenshot: *ESXi vSwitch-Lab created*

2. **Create Port Group**
   - **Port groups → Add port group**
   - Name: `LabNet`, Virtual switch: `vSwitch-Lab`, VLAN ID: **0 (None)**
   - Create

   📸 Screenshot: *ESXi Port Group LabNet created*

3. **Plan IPs**
   - DC01  : `192.168.56.10/24`
   - WIN11 : `192.168.56.20/24`
   - RHEL9 : `192.168.56.30/24`
   - Gateway: none (isolated lab) or a NAT VM if you need Internet

4. **Create VMs**
   - **DC01**: Windows Server 2022, 2 vCPU, 4–8 GB RAM, 60 GB disk
   - **WIN11**: Windows 11 Pro, 2 vCPU, 4–8 GB RAM
   - **RHEL9**: Rocky/RHEL 9 Minimal, 2 vCPU, 2–4 GB RAM

   📸 Screenshot: *VM inventory showing DC01, WIN11, RHEL9 attached to LabNet*


## Step 2 — Windows Domain Controller (AD DS + DNS + GPO)

**Goal:** Promote `DC01` to a domain controller for `mylab.local`, set basic GPO baseline, and create OUs, users, and groups.

### Configure Static IP & Hostname
- Hostname: `DC01`
- IP: `192.168.56.10/24`
- DNS: `127.0.0.1` (after AD install; can be itself)
- Workgroup: `WORKGROUP` (pre-AD)

📸 Screenshot: *DC01 network adapter static IP settings*

### Install AD DS + DNS
**GUI (simple):**
- Server Manager → **Add roles and features** → **Active Directory Domain Services** (+ DNS)
- After install: **Promote this server to a domain controller** → **Add a new forest**
- Domain: `mylab.local`
- DSRM password: (lab value)

📸 Screenshot: *AD DS promotion wizard summary*

**PowerShell (optional):**
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "mylab.local" -DomainNetbiosName "MYLAB" -InstallDNS:$true `
  -SafeModeAdministratorPassword (Read-Host -AsSecureString "Enter DSRM password") -Force
```

📸 Screenshot: *Server Manager shows AD DS and DNS installed*

### Create OUs, Groups, Users (script)
Run on DC01 as Domain Admin:
```powershell
.\02-windows-dc\scripts\create-ou-users.ps1
```

📸 Screenshot: *ADUC showing OU=Lab with Windows, Linux sub-OUs and groups/users*

### Baseline GPO
Create a GPO `Baseline - Security` and link it at the domain root with:
- **Password Policy:** Min length 12, complexity ON
- **Account Lockout:** Threshold 5, duration 15m
- **Interactive Logon Message:** Legal banner
- **Audit Policy:** Enable success/failure for Logon/Logoff, Account Logon, Policy Change, System

📸 Screenshot: *GPO Management showing Baseline - Security linked to mylab.local*


### GPO Settings Reference (Inline)

**GPO Name:** `Baseline - Security`  
**Link:** Domain root (`mylab.local`)

1) **Password & Account Lockout**
- Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Password Policy
  - Minimum password length: **12**
  - Password must meet complexity requirements: **Enabled**
- … → Account Lockout Policy
  - Account lockout threshold: **5**
  - Account lockout duration: **15 minutes**
  - Reset account lockout counter after: **15 minutes**

2) **Interactive Logon Banner**
- Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → Security Options
  - Interactive logon: Message title: `Authorized Use Only`
  - Interactive logon: Message text:
    ```
    You are accessing a lab system. Unauthorized use is prohibited. Activity may be monitored.
    ```

3) **Advanced Audit Policy**
- Computer Configuration → Policies → Windows Settings → Security Settings → Advanced Audit Policy Configuration
  - Audit Logon/Logoff: Success, Failure
  - Audit Account Logon: Success, Failure
  - Audit Policy Change: Success, Failure
  - Audit System: Success, Failure

4) **Windows Defender Firewall**
- Ensure **Domain Profile** is **On** and inbound rules are default


## Step 3 — Windows Client Join (WIN11)

**Goal:** Join a Windows 10/11 machine to `mylab.local` and verify policy application.

1. Hostname: `WIN11`
2. Static IP: `192.168.56.20/24`, DNS: `192.168.56.10`
3. Join Domain: **Settings → System → About → Rename this PC (advanced) → Domain** → `mylab.local`
4. Reboot and log in as `mylab\alice.admin`

📸 Screenshot: *WIN11 About page showing domain join*

**Validate GPO**
```powershell
gpupdate /force
gpresult /H C:\Users\Public\gpresult.html
start C:\Users\Public\gpresult.html
```
📸 Screenshot: *gpresult report showing Baseline - Security applied*


## Step 4 — Linux Domain Join (RHEL/Rocky 9 with realmd/SSSD)

**Goal:** Join Linux to `mylab.local` using realmd/SSSD and grant sudo to AD group `Linux_Admins`.

> Example host: `RHEL9` with static IP `192.168.56.30`, DNS `192.168.56.10`

**Packages**
```bash
sudo dnf install -y realmd sssd sssd-tools oddjob oddjob-mkhomedir adcli krb5-workstation samba-common-tools
sudo dnf install -y openscap-scanner scap-security-guide  # for later
```

**Discover & Join**
```bash
realm discover mylab.local
sudo realm join mylab.local -U Administrator
```

📸 Screenshot: *realm join success message*

**Enable home-dir creation & SSSD**
```bash
sudo authselect select sssd with-mkhomedir --force
sudo systemctl enable --now sssd
```

**Sudo for AD group**
```bash
echo '%MYLAB\\Linux_Admins ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-linux-admins
sudo visudo -cf /etc/sudoers.d/90-linux-admins
```

**Validate**
```bash
id "mylab\\alice.admin"
getent group "MYLAB\\Linux_Admins"
su - "mylab\\alice.admin" -c 'sudo -l'
```
📸 Screenshot: *id output for mylab\alice.admin*


## Step 5 — Security Baselines

**Windows (via GPO)**
- Create/Link GPO **Baseline - Security** at `mylab.local`
- Configure settings per reference above
- Force update on clients: `gpupdate /force`

📸 Screenshot: *GPO Management Editor showing password policy and banner*

**Linux (OpenSCAP)**
```bash
sudo oscap xccdf eval --profile stig --report /root/stig-report.html /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml
```
📸 Screenshot: *OpenSCAP report summary*


### Linux OpenSCAP Notes

Packages: `openscap-scanner`, `scap-security-guide`  
Open `/root/stig-report.html` in a browser (copy it to your desktop if needed).


## Step 6 — Validation & Evidence

**Windows**
```powershell
gpresult /H C:\Users\Public\gpresult.html
start C:\Users\Public\gpresult.html
```
📸 Screenshot: *GPO applied report*

**Linux**
```bash
bash 06-validation/scripts/linux-domain-status.sh
```
📸 Screenshot: *realm list / id / sudo -l outputs*

**Deliverables Checklist**
- [ ] Domain functional and DNS resolving AD records
- [ ] WIN11 joined and GPO applied
- [ ] RHEL9 joined and AD users can log in
- [ ] `Linux_Admins` group grants sudo on RHEL9
- [ ] OpenSCAP report captured in repo


---

## Architecture (reference)
```
ESXi vSwitch (internal only)
  ├── DC01  : Windows Server 2022 (AD DS + DNS + GPO) – 192.168.56.10
  ├── WIN11 : Windows 11 Pro domain client           – 192.168.56.20
  └── RHEL9 : Rocky/RHEL 9 server (sssd/realmd)      – 192.168.56.30
Domain: mylab.local
```

## Repo Pointers
- PowerShell OU/users script: `02-windows-dc/scripts/create-ou-users.ps1`
- Linux join helpers: `04-linux-join/scripts/`
- Validation script: `06-validation/scripts/linux-domain-status.sh`
- Screenshot folders: `screenshots/<step>/`

## Execution Checklist
See `assets/checklist.md` and tick items as you capture evidence.