# 03 — Windows Client Join (WIN11)

**Goal:** Join a Windows 10/11 machine to `mylab.local` and verify policy application.**

## Steps
1. Hostname: `WIN11`
2. Static IP: `192.168.56.20/24`, DNS: `192.168.56.10`
3. Join Domain: **Settings → System → About → Rename this PC (advanced) → Domain** → `mylab.local`
4. Reboot and log in as `mylab\alice.admin`

📸 Screenshot: *WIN11 About page showing domain join*

## Validate GPO
Open an elevated PowerShell and run:
```powershell
gpresult /H C:\Users\Public\gpresult.html
start C:\Users\Public\gpresult.html
```

📸 Screenshot: *gpresult report showing Baseline - Security applied*
