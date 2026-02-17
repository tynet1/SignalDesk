#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo bash scripts/set_vnc_password.sh"
  exit 1
fi

SIGNALDESK_USER="${SIGNALDESK_USER:-signaldesk}"
SIGNALDESK_GROUP="${SIGNALDESK_GROUP:-signaldesk}"
SIGNALDESK_HOME="${SIGNALDESK_HOME:-/var/lib/signaldesk}"

read -r -s -p "Enter new VNC password: " PASS1
echo
read -r -s -p "Confirm new VNC password: " PASS2
echo

if [[ -z "${PASS1}" || "${PASS1}" != "${PASS2}" ]]; then
  echo "Passwords do not match or are empty."
  exit 1
fi

su -s /bin/bash -c "x11vnc -storepasswd '${PASS1}' '${SIGNALDESK_HOME}/.vnc/passwd'" "${SIGNALDESK_USER}" >/dev/null
install -m 0640 -o root -g "${SIGNALDESK_GROUP}" "${SIGNALDESK_HOME}/.vnc/passwd" /etc/signaldesk/vnc.pass
echo "Updated /etc/signaldesk/vnc.pass"
echo "Restart VNC service: sudo systemctl restart signaldesk-x11vnc.service"
