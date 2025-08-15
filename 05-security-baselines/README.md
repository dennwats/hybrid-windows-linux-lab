# 05 — Security Baselines

This step applies **basic** baselines suitable for a lab demo.

## Windows (via GPO)
- Create/Link GPO **Baseline - Security** at `mylab.local`
- Configure settings in `windows-gpo-settings.md`
- Force update: `gpupdate /force` (client side)

📸 Screenshot: *GPO Management Editor showing password policy and banner*

## Linux (OpenSCAP)
Scan with STIG profile (or CIS):
```bash
sudo oscap xccdf eval --profile stig --report /root/stig-report.html /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml
```

📸 Screenshot: *OpenSCAP report summary in a browser*
