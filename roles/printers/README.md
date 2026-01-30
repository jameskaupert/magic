# Ansible Role: Printer (Driverless IPP)

Sets up a network printer on Arch Linux using driverless IPP Everywhere printing with mDNS discovery.

## Features

- Installs CUPS, Avahi, and poppler for printing, network discovery, and PDF processing
- Configures nsswitch.conf for mDNS hostname resolution
- Works around cups-filters/poppler library version mismatch (common on Arch as of early 2026)
- Discovers printer automatically via mDNS (no hardcoded IP)
- Uses IPP Everywhere for driverless printing
- Idempotent: safe to run multiple times, updates URI if printer moves

## Requirements

- Arch Linux (uses `pacman`)
- Printer must be on the same network and mDNS-capable
- Printer must support IPP Everywhere (most modern printers do)

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `printer_mdns_name` | `HP LaserJet Pro M118dw` | mDNS service name to search for |
| `printer_cups_name` | `HP_LaserJet_Pro_M118dw` | Name in CUPS (no spaces) |
| `printer_description` | `HP LaserJet Pro M118dw (WiFi)` | Human-readable description |
| `printer_location` | `""` | Physical location (optional) |
| `printer_set_default` | `true` | Set as system default printer |
| `printer_mdns_service` | `_ipp._tcp` | mDNS service type |

## Example Playbook

```yaml
- hosts: workstation
  roles:
    - role: printer
      vars:
        printer_location: "Home Office"
```

## Manual Verification

After running the role:

```bash
# Check printer status
lpstat -p

# Print a test page
echo "Test" | lp

# Browse available network printers
avahi-browse -rt _ipp._tcp
```

## Troubleshooting

**libpoppler-cpp.so.3 error / Filter failed:**
As of early 2026, there's a version mismatch between `cups-filters` and `poppler` on Arch. The role works around this by symlinking `.so.3` to `.so.2`. If a future poppler update provides `.so.3` natively, you may need to remove the symlink:
```bash
sudo rm /usr/lib/libpoppler-cpp.so.3
sudo ldconfig
```

**Printer not discovered:**
- Ensure printer is powered on and connected to WiFi
- Check that avahi-daemon is running: `systemctl status avahi-daemon`
- Manually browse: `avahi-browse -rt _ipp._tcp`
- The mDNS name must match exactly what the printer advertises

**Print jobs stuck:**
- Check CUPS status: `systemctl status cups`
- View CUPS error log: `journalctl -u cups`
- Verify printer is accepting: `lpstat -a`

**Cannot resolve printer hostname:**
- Verify nsswitch.conf has `mdns_minimal` before `dns`
- Test resolution: `getent hosts <printer-hostname>.local`

## Dependencies

None (uses `community.general.pacman` from ansible-core).

## License

MIT
