# Windows & Linux Hybrid Admin Lab

**Goal:** Build a small, realistic enterprise lab that proves cross‑platform administration:
- Windows Server **Active Directory** + DNS + GPO
- A Windows 10/11 domain client
- A **Rocky/RHEL 9** Linux server joined to AD with **SSSD/realmd**
- Security baselines: password policy, banners, audit, and **OpenSCAP** scan on Linux
- Group‑based **sudo** for AD group `Linux_Admins`
- Step‑by‑step docs with **screenshots placeholders** and validation scripts

> Use this repo as your GitHub project. Commit screenshots into `/screenshots/<step>/` as you go.

## Architecture

```
ESXi vSwitch (internal only)
  ├── DC01  : Windows Server 2022 (AD DS + DNS + GPO) – 192.168.56.10
  ├── WIN11 : Windows 11 Pro domain client           – 192.168.56.20
  └── RHEL9 : Rocky/RHEL 9 server (sssd/realmd)      – 192.168.56.30
Domain: mylab.local
```

## Quick Start

1. Follow the steps in order:
   - [01 - ESXi Networking](01-esxi-networking/README.md)
   - [02 - Windows Domain Controller](02-windows-dc/README.md)
   - [03 - Windows Client Join](03-windows-client/README.md)
   - [04 - Linux Domain Join](04-linux-join/README.md)
   - [05 - Security Baselines](05-security-baselines/README.md)
   - [06 - Validation & Evidence](06-validation/README.md)

2. After each subsection, add screenshots into `/screenshots/<step>/` where you see **📸 Screenshot** lines.

3. When finished, push to GitHub, then link this repo on your resume.

## Repo Layout

```
.
├── 01-esxi-networking/
├── 02-windows-dc/
│   └── scripts/
├── 03-windows-client/
├── 04-linux-join/
│   └── scripts/
├── 05-security-baselines/
├── 06-validation/
│   └── scripts/
├── screenshots/
│   ├── 01-esxi-networking/
│   ├── 02-windows-dc/
│   ├── 03-windows-client/
│   ├── 04-linux-join/
│   ├── 05-security-baselines/
│   └── 06-validation/
└── assets/
```

## Notes

- Use **Rocky Linux 9** to avoid subscription hurdles, or RHEL 9 if you prefer.
- Use **simple, internal addressing** (e.g., `192.168.56.0/24` on an isolated ESXi vSwitch).
- Local admin creds are for lab only.
