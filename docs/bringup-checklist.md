# Bring-up Checklist

## Phase 1: Control plane only

1. Install base packages and create runtime user:

```bash
sudo bash scripts/install_debian.sh
```

2. Download SDRTrunk release:

```bash
sudo bash scripts/download_sdrtrunk.sh
```

3. Set VNC password:

```bash
sudo bash scripts/set_vnc_password.sh
```

4. Install and start services:

```bash
sudo bash scripts/install_systemd_units.sh
```

5. Validate services:

```bash
systemctl --no-pager --full status signaldesk-xvfb.service signaldesk-fluxbox.service signaldesk-x11vnc.service signaldesk-novnc.service signaldesk-sdrtrunk.service
```

6. Validate UI access over Tailscale:
- Browse to `http://<tailscale-ip>:6080/vnc.html`
- Confirm SDRTrunk window is visible and interactive

## Phase 2: Radio decode validation

1. Confirm SDRs visible:

```bash
rtl_test -t
```

2. Configure tuners/systems in SDRTrunk.
3. Validate one known active talkgroup decodes cleanly.
4. Watch CPU and memory while decoding.

## Phase 3: Audio/status web path

1. Configure one SDRTrunk streaming output destination.
2. Validate browser playback for one talkgroup.
3. Expand alias/talkgroup coverage incrementally.
4. Add service health checks and config backups.

## Acceptance criteria

- Services auto-start on reboot
- noVNC control available on Tailscale
- SDRTrunk recovers after process crash
- At least one trunked talkgroup decodes continuously
- Browser-native audio/status works for at least one stream
