# Omarchy VNC Setup & Connection Guide

This guide provides step-by-step instructions to install, configure, and manually run a VNC server on your Omarchy box (running Hyprland/Wayland). It also covers how to connect securely from an Ubuntu 20.04 client machine.

---

## 1. Setup on the Omarchy Box

### Step A: Install WayVNC

Because Omarchy runs on the Hyprland compositor under Wayland, traditional VNC servers will not work. Install `wayvnc`:

```bash
sudo pacman -S wayvnc
```

### Step B: Create a Manual Startup Script

To ensure VNC is only exposed when you want it to be, create a script to handle the creation of a virtual headless display and start the server.

1. Open a new script file:

   ```bash
   nano ~/start-vnc.sh
   ```

2. Paste the following configuration:

   ```bash
   #!/bin/bash
   echo "Creating virtual display and starting VNC server..."
   hyprctl output create headless VNC-1
   sleep 0.5
   hyprctl keyword monitor "VNC-1,1920x1080@60,auto,1"
   echo "VNC server stopped. Cleaning up virtual display..."
   hyprctl output remove VNC-1  wayvnc -o VNC-1 0.0.0.0 5900
   ```

3. Save and close the file (`Ctrl+O`, `Enter`, `Ctrl+X`).
4. Make the script executable:

   ```bash
   chmod +x ~/start-vnc.sh
   ```

5. Add the secure local ufw rule

```bash
sudo ufw allow from <local-subnet>.X.0/24 to any port 5900 proto tcp comment 'VNC Local Only'
```

6. Reload the firewall rules

```bash
sudo ufw reload
sudo ufw status verbose
# To                         Action      From
# 5900/tcp                   ALLOW IN    192.168.X.0/24             # VNC Local Only
```

### Step C: (Optional) Map to a Keyboard Shortcut

If you are physically at the Omarchy machine and want to toggle VNC on with a hotkey, add this line to your `~/.config/hypr/hyprland.conf`:

```text
bind = SUPER, V, exec, ~/start-vnc.sh
```

---

## 2. How to Start the VNC Server Manually

When you need to connect from your remote machine, trigger the script using **one** of these options:

* **Option 1 (From the Ubuntu machine via SSH):** Run `ssh user@<OMARCHY_IP> "~/start-vnc.sh"` in your Ubuntu terminal. Keep the terminal window open during your session.
* **Option 2 (Physically at the Omarchy box):** Press `Super + V` (if you added the hotkey configuration above) or run `./start-vnc.sh` directly in a terminal.

*To close the server when done, simply press `Ctrl+C` in the terminal running the script.*

---

## 3. Connecting from your Ubuntu 20.04 Machine

You can connect using **Remmina**, the default built-in remote desktop app, or via the terminal using **TigerVNC**.

### Method A: Using Remmina (GUI)

1. Open **Remmina** from your Ubuntu application menu.
2. Change the protocol dropdown menu (next to the address bar) from **RDP** to **VNC**.
3. Enter your Omarchy box local IP address and port: `<OMARCHY_IP>:5900`
4. Press **Enter** to connect.
5. Toggling the Grab: Simply tapping the **Right-Ctrl** key once by itself acts as a master toggle switch.
6. To drop into true Fullscreen Mode (which hides all Ubuntu panels and dock elements), press: **Right-Ctrl + F**

### Method B: Using TigerVNC (Terminal)

1. Install the viewer if you don't have it:

   ```bash
   sudo apt update && sudo apt install tigervnc-viewer
   ```

2. Launch the connection directly from your terminal:

   ```bash
   xtigervncviewer <OMARCHY_IP>:5900
   ```
