# Omarchy custom configuration

## Terminal

### Foot (default terminal for Quattro)

`~/.config/foot/foot.ini`

```

font=JetBrainsMono Nerd Font:size=11
```

### Alacritty

`~/.config/alacritty/alacritty.toml`

```
[font]
...
size = 11
```

## Hyprland (window manager)

### Monitor scaling

`~/.config/hypr/monitors.lua`

```lua
local omarchy_gdk_scale = 2
```

### Keyboard (pl)

`~/.config/hypr/input.lua`

```lua
kb_layout=pl,us
```

### Touchpad natural scrolling

`~/.config/hypr/input.lua`

```lua
touchpad {
  -- use natural (inverse) scrolling
  natural_scroll = true
}
```

### Follow mouse

`~/.config/hypr/input.lua`

```lua
-- You must click a window to focus it with the mouse
follow_mouse = 2
```

### hypr additional bindings

`~/.config/hypr/bindings.lua`

```lua
-- Change full screen with full width full screen
hl.unbind("SUPER + F")
hl.unbind("SUPER + ALT + F")
o.bind("SUPER + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
o.bind("SUPER + ALT + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
```
