# SignalDesk

SignalDesk is a Debian-first deployment blueprint for running SDRTrunk headless with:

- Browser-accessible control via noVNC
- Full app control via VNC
- Local-only/Tailscale-only network exposure
- A clean path to add a web audio/status layer

## What this repo gives you

- `scripts/install_debian.sh`: installs required Debian packages and creates service user/paths
- `scripts/download_sdrtrunk.sh`: fetches and unpacks a pinned SDRTrunk release
- `scripts/sdrtrunk-launch.sh`: stable launch wrapper for SDRTrunk on virtual display
- `scripts/set_vnc_password.sh`: set/rotate VNC password
- `scripts/check_rtl_sdr.sh`: validates RTL-SDR dongle visibility and driver handoff
- `deploy/systemd/*.service`: production-friendly service units
- `docs/`: compatibility checks and bring-up runbook
- `CHANGELOG.md`: deployment-relevant changes and fixes

## Quick start

1. Install base dependencies:

```bash
sudo bash scripts/install_debian.sh
```

2. Download SDRTrunk (default pinned release: `v0.6.1`):

```bash
sudo bash scripts/download_sdrtrunk.sh
```

3. Set your VNC password:

```bash
sudo bash scripts/set_vnc_password.sh
```

4. Install and start services:

```bash
sudo bash scripts/install_systemd_units.sh
```

5. Access over Tailscale:

- noVNC URL: `http://<tailscale-ip>:6080/vnc.html`

6. Validate SDR dongles:

```bash
bash scripts/check_rtl_sdr.sh
```

## Service layout

- Display: `Xvfb :99`
- VNC server: `x11vnc` on `127.0.0.1:5900` (local bridge target)
- Web VNC bridge: `websockify` + noVNC on `0.0.0.0:6080`
- SDRTrunk: runs on display `:99` under user `signaldesk`

## Data paths

- Config/log base: `/var/lib/signaldesk`
- SDRTrunk app files: `/opt/signaldesk/sdrtrunk`
- VNC password file: `/etc/signaldesk/vnc.pass`

## Security baseline

- Keep noVNC and VNC on Tailscale network only.
- Do not publish ports 5900/6080 to WAN.
- Use ACLs in Tailscale to restrict client access.

## Next phase (audio/status web)

Use SDRTrunk playlist streaming outputs to feed a local web audio/status service.
See `docs/bringup-checklist.md` for acceptance criteria and staged rollout.
Design detail is in `docs/audio-status-blueprint.md`.
