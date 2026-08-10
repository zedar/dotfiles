# Slimbook AI 9 365 — Suspend Issue Resolution Guide

This document outlines the diagnostic steps and final solution implemented to fix the suspend/resume issue on the **Slimbook AI 9 365** laptop running **Omarchy Linux** with the **Limine Bootloader**.

---

## 📋 Problem Description
* **Symptom:** After triggering a suspend (`s2idle`), the display goes black, but the laptop's power diode remains **solid on** instead of transitioning to a blinking status. The system completely freezes, ignoring keyboard/mouse inputs, forcing a hard manual shutdown via the power button.
* **Root Cause:** A critical upstream power-state management regression in the **Linux 7.1.x kernel branch** breaks the power transition state handshake between the `amdgpu` driver and the AMD Strix Point (Ryzen AI 9) System Management Unit (SMU).

---

## 🛠️ Step-by-Step Resolution

### Step 1: Verification & Diagnostics
1. **Check Supported Sleep States:** Run `cat /sys/power/mem_sleep` to verify the hardware targets Suspend-to-Idle. The output correctly highlighted `[s2idle]`, confirming it was not attempting an invalid legacy legacy state (`deep`).
2. **Identify Kernel Version:** Checked via `uname -r`, exposing the active, bugged rolling package version: `7.1.4-arch1-1`.

### Step 2: Install the Long-Term Support (LTS) Pipeline
To bypass the faulty code path in the 7.1.x series, the stable LTS kernel infrastructure was deployed alongside the active environment:
```bash
sudo pacman -S linux-lts linux-lts-headers
```
*(Note: Omarchy's packaging hooks automatically handle the execution of `mkinitcpio` in the background to build the necessary safe initramfs ramdisk files).*

### Step 3: Link the New Images to Limine
Because Limine relies on exact physical file listings to build its boot menu selections, the configurations were updated to allow dual-boot execution.

1. **Locate the Active Configuration File:**
   ```bash
   ls /boot/limine.conf /boot/limine/limine.conf /boot/EFI/limine/limine.conf
   ```
2. **Append the Secondary Profile:** A duplicate block was configured targeting the newly introduced LTS images inside the active config file:
   ```text
   :Omarchy Linux LTS
       protocol: linux
       kernel_path: boot://(partition_uuid)/boot/vmlinuz-linux-lts
       module_path: boot://(partition_uuid)/boot/initramfs-linux-lts.img
       cmdline: rw root=UUID=(root_uuid) quiet
   ```

### Step 4: Verification and Final Deployment
1. Restarted the machine and selected the newly exposed **Omarchy Linux LTS** item from the Limine menu splash.
2. Verified the active tracking architecture environment via terminal:
   ```bash
   uname -r
   ```
   *Output accurately confirmed fallback: `6.18.39-1-lts`.*
3. **Result:** Triggering suspend now safely allows the power diode to start blinking, cutting power to components cleanly and resuming instantly upon any keypress or lid toggle.

---

## 💡 Key Takeaways & Long-Term Management
* **Co-Existing Architecture:** The original rolling kernel (`7.1.4`) is still intact on the drive. No packages or modifications were destroyed during the deployment.
* **Testing Future Updates:** You can safely run the LTS kernel branch for everyday stability. In the future, if you wish to see if upstream kernel developers have patched the Ryzen AI 9 365 power states in later `7.x` or `7.y` iterations, simply reboot, pick your primary "Omarchy Linux" option in Limine, and attempt a suspend cycle. If it freezes, toggle the boot selection right back to LTS.