# Omarchy custom configuration

## Monitor scaling (Hyprland)

`~/.config/hypr/monitors.conf`

```
env = GDK_SCALE,2
monitor=,preferred,auto,2
```

## Terminal (alacritty) font size

`~/.config/alacritty/alacritty.toml`

```
[font]
...
size = 10
```

## Keyboard (pl)

`~/.config/hypr/input.conf`

```
kb_layout=pl,us
```

## Touchpad natural scrolling

`~/.config/hypr/input.conf`

```
touchpad {
  # use natural (inverse) scrolling
  natural_scroll = true
}
```

## Follow mouse

`~/.config/hypr/input.conf`

```
# You must click a window to focus it with the mouse
follow_mouse = 2
```

# hypr additional bindings

```bash
# Change full screen with full width full screen
unbind = SUPER, F
unbind = SUPER ALT, F
bindd = SUPER ALT, F, Full screen, fullscreen, 0
bindd = SUPER, F, Full width, fullscreen, 1

# Activate window in a group by number

bindd = SUPER CTRL, code:10, Switch to group window 1, changegroupactive, 1
bindd = SUPER CTRL, code:11, Switch to group window 2, changegroupactive, 2
bindd = SUPER CTRL, code:12, Switch to group window 3, changegroupactive, 3
bindd = SUPER CTRL, code:13, Switch to group window 4, changegroupactive, 4
bindd = SUPER CTRL, code:14, Switch to group window 5, changegroupactive, 5
```
