#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo bash scripts/install_systemd_units.sh"
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_DIR="${SIGNALDESK_INSTALL_DIR:-/opt/signaldesk}"
SIGNALDESK_USER="${SIGNALDESK_USER:-signaldesk}"

if ! id -u "${SIGNALDESK_USER}" >/dev/null 2>&1; then
  echo "Error: user '${SIGNALDESK_USER}' not found. Run install_debian.sh first."
  exit 1
fi

if [[ ! -f /etc/signaldesk/vnc.pass ]]; then
  echo "Error: /etc/signaldesk/vnc.pass not found. Run install_debian.sh first."
  exit 1
fi

echo "[1/3] Installing runtime scripts..."
install -d -m 0755 -o root -g root "${INSTALL_DIR}/scripts"
install -m 0755 -o root -g root "${REPO_DIR}/scripts/sdrtrunk-launch.sh" "${INSTALL_DIR}/scripts/sdrtrunk-launch.sh"

echo "[2/3] Installing systemd units..."
install -m 0644 -o root -g root "${REPO_DIR}"/deploy/systemd/signaldesk-*.service /etc/systemd/system/
systemctl daemon-reload

echo "[3/3] Enabling services..."
systemctl enable --now signaldesk-xvfb.service
systemctl enable --now signaldesk-fluxbox.service
systemctl enable --now signaldesk-x11vnc.service
systemctl enable --now signaldesk-novnc.service
systemctl enable --now signaldesk-sdrtrunk.service

echo "SignalDesk services installed and started."
