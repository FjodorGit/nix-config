{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  networking = {
    hostName = "server";
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
    hosts = {
      "2a01:4f8:c010:d56::2" = [ "github.com" ];
      "2a01:4f8:c010:d56::3" = [ "api.github.com" ];
      "2a01:4f8:c010:d56::4" = [ "codeload.github.com" ];
      "2a01:4f8:c010:d56::6" = [ "ghcr.io" ];
      "2a01:4f8:c010:d56::7" = [
        "pkg.github.com"
        "npm.pkg.github.com"
        "maven.pkg.github.com"
        "nuget.pkg.github.com"
        "rubygems.pkg.github.com"
      ];
      "2a01:4f8:c010:d56::8" = [ "uploads.github.com" ];
      "2606:50c0:8000::133" = [
        "objects.githubusercontent.com"
        "raw.githubusercontent.com"
        "gist.githubusercontent.com"
        "avatars.githubusercontent.com"
      ];
      "2606:50c0:8000::154" = [ "github.githubassets.com" ];
    };

    firewall.checkReversePath = "loose";
    wg-quick.interfaces.wgcf = {
      privateKeyFile = "/home/fjk/wgcf-private-key";

      address = [ "172.16.0.2/32" ];

      dns = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1001"
        "2606:4700:4700::1111"
      ];
      mtu = 1420;

      table = "off";
      postUp = ''
        ip route add default dev wgcf table 51820
        ip rule add not fwmark 51820 table 51820
        ip rule add table main suppress_prefixlength 0
      '';
      postDown = ''
        ip rule del not fwmark 51820 table 51820
        ip rule del table main suppress_prefixlength 0
      '';

      peers = [
        {
          publicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
          endpoint = "[2606:4700:d0::a29f:c001]:2408";
          allowedIPs = [ "0.0.0.0/0" ];
          persistentKeepalive = 25;
        }
      ];
    };
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
      dns = [
        "2a01:4ff:ff00::add:1"
        "2a01:4ff:ff00::add:2"
      ];
    };
  };

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

  users.users.fjk = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmu3RKLj4DK1EE1m+tOFC/JK4Lj+oALkXP3O2pg3qk1 fjk@nixos"
    ];
  };

  system.stateVersion = "24.11";
}
