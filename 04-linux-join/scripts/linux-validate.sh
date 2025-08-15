#!/usr/bin/env bash
# linux-validate.sh: Basic checks for AD join on Rocky/RHEL 9
set -euo pipefail

echo "=== Domain Discovery ==="
realm discover mylab.local || true

echo -e "\n=== realm list ==="
realm list || true

echo -e "\n=== SSSD Domains ==="
sssctl domain-list || true

echo -e "\n=== id alice.admin ==="
id "mylab\\alice.admin" || true

echo -e "\n=== getent group Linux_Admins ==="
getent group "MYLAB\\Linux_Admins" || true

echo -e "\n=== sudo -l (as alice.admin) ==="
su - "mylab\\alice.admin" -c 'sudo -l' || true
