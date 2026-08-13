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
