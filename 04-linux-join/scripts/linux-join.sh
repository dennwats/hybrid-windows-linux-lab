#!/usr/bin/env bash
# linux-join.sh: Join Rocky/RHEL 9 host to AD 'mylab.local'
set -euo pipefail

DOMAIN="mylab.local"
ADMIN_USER="${ADMIN_USER:-Administrator}"

echo "[*] Installing packages..."
sudo dnf install -y realmd sssd sssd-tools oddjob oddjob-mkhomedir adcli krb5-workstation samba-common-tools

echo "[*] Enabling mkhomedir and sssd..."
sudo authselect select sssd with-mkhomedir --force
sudo systemctl enable --now sssd

echo "[*] Discovering domain..."
realm discover "$DOMAIN" || true

echo "[*] Joining domain $DOMAIN ... (you may be prompted for $ADMIN_USER password)"
sudo realm join "$DOMAIN" -U "$ADMIN_USER"

echo "[*] Configuring sudoers for MYLAB\\Linux_Admins ..."
echo '%MYLAB\\Linux_Admins ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-linux-admins >/dev/null
sudo visudo -cf /etc/sudoers.d/90-linux-admins

echo "[*] Done. Validate with: id 'mylab\\alice.admin' && getent group 'MYLAB\\Linux_Admins'"
