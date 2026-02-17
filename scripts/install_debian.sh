#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo bash scripts/install_debian.sh"
  exit 1
fi

SIGNALDESK_USER="${SIGNALDESK_USER:-signaldesk}"
SIGNALDESK_GROUP="${SIGNALDESK_GROUP:-signaldesk}"
SIGNALDESK_HOME="${SIGNALDESK_HOME:-/var/lib/signaldesk}"
SIGNALDESK_INSTALL_DIR="${SIGNALDESK_INSTALL_DIR:-/opt/signaldesk}"

echo "[1/5] Installing OS packages..."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  xvfb \
  x11vnc \
  novnc \
  websockify \
  fluxbox \
  unzip \
  curl \
  ca-certificates \
  procps \
  usbutils \
  rtl-sdr \
  libusb-1.0-0 \
  libgtk-3-0 \
  libglib2.0-0 \
  libx11-6 \
  libxext6 \
  libxrender1 \
  libxtst6 \
  libxi6 \
  libxrandr2 \
  libxfixes3 \
  libasound2

echo "[2/5] Creating user/group..."
if ! getent group "${SIGNALDESK_GROUP}" >/dev/null 2>&1; then
  groupadd --system "${SIGNALDESK_GROUP}"
fi
if ! id -u "${SIGNALDESK_USER}" >/dev/null 2>&1; then
  useradd \
    --system \
    --gid "${SIGNALDESK_GROUP}" \
    --home-dir "${SIGNALDESK_HOME}" \
    --shell /usr/sbin/nologin \
    "${SIGNALDESK_USER}"
fi
usermod -aG plugdev "${SIGNALDESK_USER}" || true

echo "[3/5] Creating directories..."
install -d -m 0755 -o "${SIGNALDESK_USER}" -g "${SIGNALDESK_GROUP}" "${SIGNALDESK_HOME}"
install -d -m 0755 -o "${SIGNALDESK_USER}" -g "${SIGNALDESK_GROUP}" "${SIGNALDESK_HOME}/.vnc"
install -d -m 0755 -o "${SIGNALDESK_USER}" -g "${SIGNALDESK_GROUP}" "${SIGNALDESK_HOME}/logs"
install -d -m 0755 -o root -g root "${SIGNALDESK_INSTALL_DIR}"
install -d -m 0750 -o root -g "${SIGNALDESK_GROUP}" /etc/signaldesk

# Prevent kernel DVB drivers from claiming RTL dongles needed by rtl-sdr.
cat > /etc/modprobe.d/blacklist-rtl-sdr.conf <<'EOF'
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
EOF
modprobe -r dvb_usb_rtl28xxu rtl2832 rtl2830 2>/dev/null || true

echo "[4/5] Creating initial VNC password file..."
if [[ ! -f /etc/signaldesk/vnc.pass ]]; then
  INIT_PASS="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 24 || true)"
  if [[ -z "${INIT_PASS}" ]]; then
    echo "Failed generating initial password bytes."
    exit 1
  fi
  su -s /bin/bash -c "x11vnc -storepasswd '${INIT_PASS}' '${SIGNALDESK_HOME}/.vnc/passwd'" "${SIGNALDESK_USER}"
  cp "${SIGNALDESK_HOME}/.vnc/passwd" /etc/signaldesk/vnc.pass
  chmod 0640 /etc/signaldesk/vnc.pass
  chown root:"${SIGNALDESK_GROUP}" /etc/signaldesk/vnc.pass
  echo "Created /etc/signaldesk/vnc.pass with a random initial password."
  echo "Set your own password now: sudo bash scripts/set_vnc_password.sh"
fi

echo "[5/5] Install complete."
echo "Next: sudo bash scripts/download_sdrtrunk.sh"
