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
