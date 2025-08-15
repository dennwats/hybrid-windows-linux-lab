# 06 — Validation & Evidence

Run the checks and capture screenshots of the outputs.

## Windows
- On **WIN11**:
  ```powershell
  gpresult /H C:\Users\Public\gpresult.html
  start C:\Users\Public\gpresult.html
  ```
  📸 Screenshot: *GPO applied report*

## Linux
- On **RHEL9**:
  ```bash
  bash scripts/linux-domain-status.sh
  ```
  📸 Screenshot: *realm list / id / sudo -l outputs*

## Deliverables Checklist
- [ ] Domain functional and DNS resolving AD records
- [ ] WIN11 joined and GPO applied
- [ ] RHEL9 joined and AD users can log in
- [ ] `Linux_Admins` group grants sudo on RHEL9
- [ ] OpenSCAP report captured in repo
