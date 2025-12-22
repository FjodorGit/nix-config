# nix-config
My Nix Config

## Setup on a new machine

1. Install NixOS
2. Clone this repo to `~/.dotfiles`
3. Copy the generated hardware config:
   ```bash
   cp /etc/nixos/hardware-configuration.nix ~/.dotfiles/
   ```
4. Update user-specific variables in `flake.nix`:
   - `username` - your username
   - `hostname` - your machine hostname
   - `gitUsername` - your git username
   - `gitEmail` - your git email
5. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake ~/.dotfiles
   ```

## Note

`hardware-configuration.nix` is machine-specific and should not be committed to git. Each machine needs its own hardware configuration.
