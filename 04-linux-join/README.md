# 04 — Linux Domain Join (RHEL/Rocky 9)

**Goal:** Join Linux to `mylab.local` using realmd/SSSD and grant sudo to AD group `Linux_Admins`.

> Example host: `RHEL9` with static IP `192.168.56.30`, DNS `192.168.56.10`

## Packages
```bash
sudo dnf install -y realmd sssd sssd-tools oddjob oddjob-mkhomedir adcli krb5-workstation samba-common-tools
sudo dnf install -y openscap-scanner scap-security-guide  # for later
```

## Discover & Join
```bash
realm discover mylab.local
sudo realm join mylab.local -U Administrator
```

If asked, provide the **Domain Admin** password.

📸 Screenshot: *realm join success message*

## Enable home-dir creation
```bash
sudo authselect select sssd with-mkhomedir --force
sudo systemctl enable --now sssd
```

## Sudo for AD group
Create a sudoers file mapping the AD group:
```bash
echo '%MYLAB\\Linux_Admins ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-linux-admins
sudo visudo -cf /etc/sudoers.d/90-linux-admins  # validate
```

> Tip: Verify exact group name via `getent group "MYLAB\\Linux_Admins"` or `getent group | grep -i linux_admins`.

## Validate
```bash
id "mylab\\alice.admin"
getent group "MYLAB\\Linux_Admins"
su - "mylab\\alice.admin" -c 'sudo -l'
```

📸 Screenshot: *id output for mylab\alice.admin*
