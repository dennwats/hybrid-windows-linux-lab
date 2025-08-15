# Windows Baseline GPO — Settings Reference

**GPO Name:** `Baseline - Security`  
**Link:** Domain root (`mylab.local`)

## 1. Password & Account Lockout
- **Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Password Policy**
  - Minimum password length: **12**
  - Password must meet complexity requirements: **Enabled**
- **… → Account Lockout Policy**
  - Account lockout threshold: **5**
  - Account lockout duration: **15 minutes**
  - Reset account lockout counter after: **15 minutes**

## 2. Interactive Logon Banner
- **Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → Security Options**
  - Interactive logon: Message title for users attempting to log on: `Authorized Use Only`
  - Interactive logon: Message text for users attempting to log on:
    ```
    You are accessing a lab system. Unauthorized use is prohibited. Activity may be monitored.
    ```

## 3. Advanced Audit Policy
- **Computer Configuration → Policies → Windows Settings → Security Settings → Advanced Audit Policy Configuration**
  - Audit Logon/Logoff: Success, Failure
  - Audit Account Logon: Success, Failure
  - Audit Policy Change: Success, Failure
  - Audit System: Success, Failure

## 4. Windows Defender Firewall
- Ensure **Domain Profile** is **On** and inbound rules are default

## 5. RDP Access (Optional)
- Allow RDP for **Domain Admins** only or a specific group (lab choice)

> After editing, run `gpupdate /force` on clients and verify with `gpresult /H C:\Users\Public\gp.html`.
