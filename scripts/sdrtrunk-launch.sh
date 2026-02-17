#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:99}"
export HOME="${HOME:-/var/lib/signaldesk}"

APP_DIR="${APP_DIR:-/opt/signaldesk/sdrtrunk}"
LOG_DIR="${LOG_DIR:-/var/lib/signaldesk/logs}"
JAR_PATH="${JAR_PATH:-${APP_DIR}/sdr-trunk.jar}"
JAVA_BIN="${JAVA_BIN:-}"

mkdir -p "${LOG_DIR}"

if [[ ! -f "${JAR_PATH}" ]]; then
  echo "Missing ${JAR_PATH}. Run scripts/download_sdrtrunk.sh first."
  exit 1
fi

if [[ -z "${JAVA_BIN}" ]]; then
  if [[ -x "${APP_DIR}/jdk/bin/java" ]]; then
    JAVA_BIN="${APP_DIR}/jdk/bin/java"
  else
    JAVA_BIN="$(command -v java || true)"
  fi
fi

if [[ -z "${JAVA_BIN}" ]]; then
  echo "No Java runtime found. Install Java or use an SDRTrunk release bundle with JRE."
  exit 1
fi

cd "${APP_DIR}"
exec "${JAVA_BIN}" \
  -Djava.awt.headless=false \
  -jar "${JAR_PATH}" \
  >> "${LOG_DIR}/sdrtrunk.stdout.log" \
  2>> "${LOG_DIR}/sdrtrunk.stderr.log"
