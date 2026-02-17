# Changelog

## Unreleased

### Fixed
- Added required JavaFX GTK runtime dependencies to Debian installer to fix SDRTrunk launch failure:
  `UnsupportedOperationException: Unable to load glass GTK library`.

### Added
- Added RTL-SDR host setup in installer:
  - Installs `rtl-sdr` and `libusb-1.0-0`
  - Blacklists conflicting kernel DVB modules (`dvb_usb_rtl28xxu`, `rtl2832`, `rtl2830`)
  - Adds `signaldesk` user to `plugdev`
- Added `scripts/check_rtl_sdr.sh` for quick dongle detection and `rtl_test` validation.
