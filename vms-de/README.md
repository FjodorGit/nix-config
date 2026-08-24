# NixOS desktop-environment test VMs

A flake that builds throwaway QEMU VMs, one per desktop environment, all
sharing a common base config. The VM mounts the host Nix store, so each
variant is cheap to build.

## Usage

    nixos-rebuild build-vm --flake .#gnome
    ./result/bin/run-nixos-vm

Swap the DE by changing the flake target: `.#kde`, `.#xfce`.

Login: user `tester`, password `tester`.

## Files

- `flake.nix`  - defines one nixosConfiguration per DE
- `base.nix`   - shared config + VM sizing (4 GiB RAM, 4 cores)
- `gnome.nix`  - GNOME + GDM
- `kde.nix`    - KDE Plasma 6 + SDDM
- `xfce.nix`   - XFCE + LightDM

## Notes

- Option paths assume NixOS 25.11+. On 25.05 or earlier, GNOME/KDE move
  back under `services.xserver.desktopManager.*` and
  `services.xserver.displayManager.*`. XFCE stays under
  `services.xserver.desktopManager.xfce` on all releases.
- Running the VM creates a `<hostname>.qcow2` state file in the working
  directory. Delete it after changing config, before rebuilding:
      rm -f *.qcow2
- Flakes only see git-tracked files. If nothing builds, run:
      git init && git add .
