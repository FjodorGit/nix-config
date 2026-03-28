{ pkgs, ... }:
{

  # ── Boot ──────────────────────────────────────────────────
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  # ── Networking (IPv6 only) ────────────────────────────────
  networking = {
    hostName = "garage"; # change if you like
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp0s31f6";
      address = [
        "2a01:4f8:2240:1149::1"
      ];
      routes = [
        { Gateway = "fe80::1"; }
      ];
      # DNS servers (Hetzner's)
      dns = [
        "2a01:4ff:ff00::add:1"
        "2a01:4ff:ff00::add:2"
      ];
    };
  };

  # ── SSH ───────────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmu3RKLj4DK1EE1m+tOFC/JK4Lj+oALkXP3O2pg3qk1 fjk@nixos"
  ];

  # ── Basic packages ────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim
    git
    btop
    curl
  ];

  # ── Firewall ──────────────────────────────────────────────
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # ── NixOS state version ──────────────────────────────────
  system.stateVersion = "24.11";
}
