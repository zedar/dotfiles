# Omarchy (Arch) Rust development environment

`Install->Development->Rust`
Omarchy uses mise as a version manager.

## Dev tools

### cmake

```bash
sudo pacman -Syu
sudo pacman -S cmake

```

### protobuf compiler

On Arch Linux, the Protocol Buffers compiler (protoc) is included directly inside the main protobuf package.
Unlike Debian or Ubuntu systems which split it into protobuf-compiler, Arch bundles the command-line compiler and core libraries together.

```bash
sudo pacman -S protobuf
```

### pkgconf

On Arch Linux, the classic pkg-config tool has been replaced by a newer, faster implementation called pkgconf. The pkgconf package completely replaces the old one and automatically provides a pkg-config command. Anything you build will look for it and find it normally.

```bash
```bash
sudo pacman -S pkgconf
```

### Nix and flake

```bash
sudo pacman -S nix
sudo systemctl enable --now nix-daemon.service
sudo gpasswd -a $USER nix-users
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Rust tools

Rust components.

```bash
rustup component add rustfmt clippy rust-analyzer
```

`sqlx-cli` for postgres

```bash
cargo install sqlx-cli --no-default-features --features postgres
```

### Just helper

```bash
sudo pacman -S just
```

### Ansible

```bash
sudo pacman -S ansible
```

### Google cloud CLI

```bash
mise search gcloud
# Tool    Description                                                                
# gcloud  GCloud CLI (Google Cloud SDK). https://github.com/mise-plugins/vfox-gcloud
# install latest version of gcloud CLI
mise install gcloud
# activate it globally
mise use -g gcloud
```

Configure gcloud

```bash
gcloud auth login
gcloud components list
gcloud components install beta
gcloud beta interactive
```

## AI tools

## opencode

TensorX is an open weight provider hosting models in Europe. Generate API key and call `/connect` to connect to TensorX.
If some models are not available add missing to `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "autoupdate": false,
  "provider": {
    "tensorx": {
      "models": {
        "qwen/qwen3.8-flash-next": {
          "name": "Qwen3.8-flash-next"
        },
        "z-ai/glm-5.3-flashqwen": {
          "name": "GLM-5.3-flash"
        }
      }
    }
  }
}
```
