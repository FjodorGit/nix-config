# NixOS Dotfiles

My personal NixOS configuration using Flakes and Home Manager.

## Prerequisites

- A fresh installation of NixOS.
- Internet connection.
- `git` installed (usually available in the minimal ISO).

## Installation

### 1. Clone the Repository

Clone this repository to your home directory:

```bash
git clone https://github.com/FjodorGit/nix-config.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Configure Hardware

The `hardware-configuration.nix` file in this repository is specific to the machine it was generated for. For a new system, you must use the one generated during your installation.

Copy your system's hardware configuration:

```bash
cp /etc/nixos/hardware-configuration.nix ~/.dotfiles/hardware-configuration.nix
```

### 3. Generate SSH Key

Generate a new SSH key for this machine:

```bash
./generate-key.sh
```

This creates a new ed25519 key at `~/.ssh/id_ed25519` and copies the public key to clipboard. Add it to GitHub/GitLab as needed.

### 4. External Secrets

Some configuration files are not stored in the repository and must be placed manually:

- **WireGuard**: Place your WireGuard config at `/home/fjk/.wireguard/wg_config.conf`.
- **Mutt**: Place your mutt config at `~/.config/mutt/muttrc`.

### 5. Apply Configuration

Build and switch to the new configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

If you are running this for the first time and the user `fjk` does not exist yet, you might need to run this as root or the initial user created during installation.

## Post-Installation

- **Reboot**: It is recommended to reboot your system to ensure all changes (kernel modules, bootloader, etc.) are applied correctly.
- **Home Manager**: Home Manager is installed as a NixOS module, so it should apply automatically on rebuild. If you need to update user-specific configs later:
  ```bash
  home-manager switch --flake .#fjk@nixos
  ```
