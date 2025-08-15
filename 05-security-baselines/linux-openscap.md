# Linux OpenSCAP — Notes

**Packages:** `openscap-scanner`, `scap-security-guide`  
**Command:**
```bash
sudo oscap xccdf eval --profile stig --report /root/stig-report.html /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml
```
Open `/root/stig-report.html` in a browser (copy it to your desktop if needed). Add a screenshot of the summary.

📸 Screenshot: *STIG report overview*
