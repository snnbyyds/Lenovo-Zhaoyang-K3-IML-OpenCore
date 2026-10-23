# Lenovo Zhaoyang K3-IML OpenCore EFI

OpenCore EFI configuration for the **Lenovo Zhaoyang K3-IML (81M4)**.

## Status

**macOS Sequoia 15.8 (24H23) successfully boots and runs on this laptop.**

This configuration includes the machine-specific USB map, CPU TSC
synchronization, non-MAT firmware adjustments, battery detection fix, and
Intel backlight fix used on macOS 15.8.

## Hardware

| Component | Specification |
| --- | --- |
| Laptop | Lenovo Zhaoyang K3-IML, machine type 81M4 |
| Motherboard | Lenovo LNVNB161216 |
| CPU | Intel Core i5-10210U, Comet Lake-U, 4 cores / 8 threads |
| Memory | 8 GB Samsung DDR4 SO-DIMM, configured at 2667 MT/s |
| Integrated graphics | Intel UHD Graphics, PCI ID `8086:9B41` |
| Discrete graphics | AMD Radeon 630, PCI ID `1002:6987` |
| Internal display | BOE NV133FHM-N6A, 1920 × 1080, connected to the Intel GPU |
| Storage | Lenovo X800 512 GB NVMe SSD, Phison PS5013-E13 controller (`1987:5013`) |
| Wi-Fi | Intel Wireless-AC 9560 (`8086:02F0`) |
| Bluetooth | Intel USB Bluetooth (`8087:0AAA`) |
| Audio codec | Realtek ALC257 (`10EC:0257`) |
| Internal microphone | Intel SST digital microphone array (`8086:AE20`) |
| Touchpad | ELAN I²C HID (`04F3:30C9`) |
| Keyboard | PS/2 keyboard (`ACPI:IDEA0100`) |
| Camera | Integrated USB camera (`5986:2115`) |

## Firmware

The following versions and settings were collected from this machine.

| Item | Version or state |
| --- | --- |
| BIOS | Lenovo CQCN42WW, version 1.42 |
| BIOS date | 2023-05-24 |
| Embedded controller | Version 1.30 |
| SSD firmware | EDFM60.0 |
| Boot mode | UEFI |
| Secure Boot | Disabled |
| SATA controller mode | AHCI |
| CFG Lock setting | Enabled |
| DVMT preallocated memory | 32 MB |
| VT-d setting | Enabled |
| UEFI Memory Attributes Table | Not available at boot (`MAT=0`) |

## Known Issues

- The built-in Intel SST digital microphone is not working.
