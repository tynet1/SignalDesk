#!/usr/bin/env bash
set -euo pipefail

if ! command -v rtl_test >/dev/null 2>&1; then
  echo "rtl_test not found. Install rtl-sdr first."
  exit 1
fi

echo "Connected USB SDR devices:"
lsusb | grep -Ei 'rtl|realtek|sdr' || true
echo
echo "rtl_test probe:"
rtl_test -t
