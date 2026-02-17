#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo bash scripts/download_sdrtrunk.sh"
  exit 1
fi

SIGNALDESK_USER="${SIGNALDESK_USER:-signaldesk}"
SIGNALDESK_GROUP="${SIGNALDESK_GROUP:-signaldesk}"
SIGNALDESK_INSTALL_DIR="${SIGNALDESK_INSTALL_DIR:-/opt/signaldesk}"
SDRTRUNK_VERSION="${SDRTRUNK_VERSION:-v0.6.1}"
SDRTRUNK_ARCHIVE="${SDRTRUNK_ARCHIVE:-sdr-trunk-linux-x86_64-${SDRTRUNK_VERSION}.zip}"
SDRTRUNK_URL="${SDRTRUNK_URL:-https://github.com/DSheirer/sdrtrunk/releases/download/${SDRTRUNK_VERSION}/${SDRTRUNK_ARCHIVE}}"
TMP_ZIP="/tmp/${SDRTRUNK_ARCHIVE}"

echo "Downloading ${SDRTRUNK_URL}"
curl -fL --retry 3 --retry-delay 2 "${SDRTRUNK_URL}" -o "${TMP_ZIP}"

echo "Unpacking to ${SIGNALDESK_INSTALL_DIR}/sdrtrunk"
rm -rf "${SIGNALDESK_INSTALL_DIR}/sdrtrunk"
unzip -q "${TMP_ZIP}" -d "${SIGNALDESK_INSTALL_DIR}/sdrtrunk"
chown -R "${SIGNALDESK_USER}:${SIGNALDESK_GROUP}" "${SIGNALDESK_INSTALL_DIR}/sdrtrunk"

echo "Installed SDRTrunk ${SDRTRUNK_VERSION}"
