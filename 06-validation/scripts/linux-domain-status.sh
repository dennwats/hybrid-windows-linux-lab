#!/usr/bin/env bash
# linux-domain-status.sh: One-shot status report for your README evidence
set -euo pipefail
OUT="/tmp/hybrid-lab-status.txt"

{
  echo "==== hostname ===="
  hostnamectl
  echo
  echo "==== DNS resolution (DC) ===="
  getent hosts dc01 || true
  echo
  echo "==== realm list ===="
  realm list || true
  echo
  echo "==== sssd service ===="
  systemctl status sssd --no-pager || true
  echo
  echo "==== id alice.admin ===="
  id "mylab\\alice.admin" || true
  echo
  echo "==== getent group Linux_Admins ===="
  getent group "MYLAB\\Linux_Admins" || true
  echo
  echo "==== sudo -l (as alice.admin) ===="
  su - "mylab\\alice.admin" -c 'sudo -l' || true
} | tee "$OUT"

echo "Wrote $OUT"
