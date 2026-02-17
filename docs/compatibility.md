# Compatibility and Pitfalls

## Known-good target

- Debian 13 (`trixie`) or newer
- SDRTrunk `v0.6.1` final
- x86_64 Linux build of SDRTrunk unless you explicitly switch archive name

## Hard requirements

- CPU architecture must match the SDRTrunk release archive (`x86_64` vs `aarch64`)
- At least 4 GB RAM (8+ GB recommended for larger systems)
- Stable USB bus for SDR dongles
- Java runtime (bundled runtime preferred)

## High-impact pitfalls

1. No X display available
- Symptom: SDRTrunk exits or JavaFX errors
- Fix: verify `signaldesk-xvfb.service` and `signaldesk-fluxbox.service` are active

2. VNC reachable but blank/black display
- Symptom: noVNC opens but no SDRTrunk window
- Fix: confirm `DISPLAY=:99` in service env and `signaldesk-sdrtrunk.service` is running

3. SDR device index shifts across reboot
- Symptom: wrong tuner assigned, decode failures
- Fix: set unique SDR serial numbers and map them predictably

4. Audio/status expectations mismatched
- Symptom: VNC works, but no browser-native audio/status
- Fix: configure SDRTrunk stream outputs and wire to a dedicated local web audio/status service

## Networking guidance with Tailscale

- Keep VNC and noVNC bound to localhost or Tailscale interface
- Restrict access with Tailscale ACLs
- Do not expose 5900/6080 to public interfaces
