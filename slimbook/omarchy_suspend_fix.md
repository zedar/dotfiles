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

Command to check if there is an updated linux-lts

```bash
sudo pacman -Q linux-lts
```

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
   uname -rshe
   ```

   *Output accurately confirmed fallback: `6.18.39-1-lts`.*
3. **Result:** Triggering suspend now safely allows the power diode to start blinking, cutting power to components cleanly and resuming instantly upon any keypress or lid toggle.

### Step 6: Fix keyboard resume after lid open

```shell
# Install slimbook-quirks
yay -S slimbook-quirk-i8042-wakeup slimbook-quirk-i8042-reset
# to remove
sudo pacman -Rns slimbook-quirk-i8042-wakeup
sudo pacman -Rns slimbook-quirk-i8042-wakeup
```

---

## Omarchy Quattro (quickshell)

### Diagnosis

Confirmed root cause — in Quattro (Omarchy 4), the old `hypridle` suspend listener in `~/.config/hypr/hypridle.conf` is a dead artifact:
* `hypridle` is not installed, nothing launches it (`autostart.lua` is empty)
* Idle is handled by the Quickshell `omarchy.idle` service (`/usr/share/omarchy/shell/plugins/services/idle/Service.qml`) — it only implements `idle.screensaver` (120s) and `idle.lock` (150s)
* Everything else is healthy: manual `systemctl` suspend works, the sleep monitor locks-before-suspend inhibitor runs, and lid-close suspend is still handled by logind (HandleLidSwitch=suspend)

### Fix

Clone the idle service plugin and add a suspend step — fully integrated with stay-awake, activity-cancel, and lock state:

1. `~/.config/omarchy/plugins/slimbook.idle/` — entire directory (3 files: `Service.qml`, `IdleModel.js`, `manifest.json`). Your user-owned clone of `omarchy.idle` with suspend support. Changes to Service.qml vs built-in:
* `idle.suspend` config key (seconds since idle began; 0/unset = disabled)
* `suspendTimer` armed at idle-cycle start, survives the lock, cleared only on activity/cancel/stay-awake
* Fires `requestSuspend()` → live guard: Discharging in BAT*/status + omarchy-shell lock isLocked → systemctl suspend; skips are logged to journald (-t omarchy-idle)
* `omarchy-shell` idle status now reports suspend, suspendArmed, timers/processes
1. ``~/.config/omarchy/shell.json` — full file. Key parts: "idle": { "screensaver": 120, "lock": 150, "suspend": 600 } plus the clone rewiring (plugins: [slimbook.idle], disabledPlugins: [omarchy.idle], cloneSourceRestores: [...])

Result: on battery → screensaver 2m, lock 2.5m, auto-suspend 10m. Plugged in → lock only, never auto-suspends. omarchy toggle idle stay-awake suppresses everything, including suspend. Lock-before-suspend already guaranteed by the existing sleep monitor.

Verified: service loads clean (service-ready, no QML errors), idle status shows correct timings, guard tested live on battery → correctly logged skipped: system not locked.

Revert anytime: `omarchy plugin remove slimbook.idle` restores the built-in, or disable it `omarchy plugin disable slimbook.idle`

---

## 💡 Key Takeaways & Long-Term Management

* **Co-Existing Architecture:** The original rolling kernel (`7.1.4`) is still intact on the drive. No packages or modifications were destroyed during the deployment.
* **Testing Future Updates:** You can safely run the LTS kernel branch for everyday stability. In the future, if you wish to see if upstream kernel developers have patched the Ryzen AI 9 365 power states in later `7.x` or `7.y` iterations, simply reboot, pick your primary "Omarchy Linux" option in Limine, and attempt a suspend cycle. If it freezes, toggle the boot selection right back to LTS.
