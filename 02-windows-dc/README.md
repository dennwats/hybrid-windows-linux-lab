# 02 — Windows Domain Controller (AD DS + DNS + GPO)

**Goal:** Promote `DC01` to a domain controller for `mylab.local`, set basic GPO baseline, and create OUs, users, and groups.

## Configure Static IP & Hostname
- Set hostname: `DC01`
- IP: `192.168.56.10/24`
- DNS: `127.0.0.1`
- Workgroup: `WORKGROUP` (pre-AD)

📸 Screenshot: *DC01 network adapter static IP settings*

## Install AD DS + DNS
### GUI (simple):
- Server Manager → **Add roles and features** → **Active Directory Domain Services** (+ DNS)
- After install: **Promote this server to a domain controller** → **Add a new forest**
- Domain: `mylab.local`
- DSRM password: (lab value)

📸 Screenshot: *AD DS promotion wizard summary*

### PowerShell (optional):
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "mylab.local" -DomainNetbiosName "MYLAB" -InstallDNS:$true `
  -SafeModeAdministratorPassword (Read-Host -AsSecureString "Enter DSRM password") -Force
```

📸 Screenshot: *Server Manager shows AD DS and DNS installed*

## Create OUs, Groups, Users
Run the helper script to scaffold OUs, groups, and sample users.

```powershell
.\scripts\create-ou-users.ps1
```

📸 Screenshot: *ADUC showing OU=Lab with Windows, Linux sub-OUs and groups/users*

## Baseline GPO
Create a GPO `Baseline - Security` and link it at the domain root with:
- **Password Policy:** Min length 12, complexity ON
- **Account Lockout:** Threshold 5, duration 15m
- **Interactive Logon Message:** Legal banner (text provided below)
- **Audit Policy:** Enable success/failure for Logon/Logoff, Account Logon, Policy Change, System, Object Access (as needed)

> Detailed keys in `../05-security-baselines/windows-gpo-settings.md`

📸 Screenshot: *GPO Management showing Baseline - Security linked to mylab.local*
