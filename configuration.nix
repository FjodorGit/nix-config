# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man pageconf
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10; # Keeps /boot from filling up with old generations
        editor = false; # Security: prevents editing kernel cmdline at boot
      };
      efi.canTouchEfiVariables = true;
      timeout = 3; # Seconds to show boot menu (0 = skip unless holding key)
    };

    kernelModules = [
      "i2c-dev"
      "kvm-intel"
    ];

    initrd.systemd.enable = true;
    kernelParams = [
      "quiet"
      "i915.enable_guc=3"
    ];
    consoleLogLevel = 0;

    # Optional: mount /tmp as tmpfs (faster, cleared on reboot)
    tmp.useTmpfs = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "fjk"
  ];

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.wg-quick.interfaces = {
    osm-net = {
      autostart = false;
      configFile = "/home/fjk/.wireguard/wg_config.conf";
    };
  };

  # Kde connect
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # required for the tuigreet to remember the user
  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter -"
  ];
  services.power-profiles-daemon.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;


  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
  };
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };

  security.pam.services.hyprlock = { };
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pki.certificateFiles = [ ./ca-certificates/mitmproxy-ca-cert.pem ];
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # MT7925 combo card comes up soft-blocked by rfkill despite powerOnBoot
  systemd.services.bluetooth-rfkill-unblock = {
    description = "Unblock Bluetooth soft-block after boot";
    after = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
    };
  };

  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  services.thermald.enable = true;

  # NVIDIA GPU support
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true; # Required for RTX 50-series
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta; # Latest drivers for RTX 5060

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides nvidia-offload command
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron apps on Wayland
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.udev = {
    enable = true;
    extraRules = ''KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"'';
  };

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # systemd.services.immorporation = {
  #   enable = true;
  #   description = "innernet client daemon for immorporation";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.innernet}/bin/innernet up immorporation --daemon --interval 45";
  #     Restart = "always";
  #     RestartSec = 10;
  #   };
  #   path = [
  #     pkgs.innernet
  #     pkgs.iproute2
  #   ];
  #   after = [
  #     "network-online.target"
  #     "nss-lookup.target"
  #   ];
  #   wants = [
  #     "network-online.target"
  #     "nss-lookup.target"
  #   ];
  #   wantedBy = [ "multi-user.target" ];
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.i2c = { };
  users.users.fjk = {
    isNormalUser = true;
    description = "fjk";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "wireshark"
      "docker"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };
  virtualisation.docker.enable = true;

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {
      inherit inputs;
    };
    users."fjk" = {
      imports = [
        ./home.nix
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.home-manager
    pkgs.innernet
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      hyprland = {
        default = [
          "gtk"
          "hyprland"
        ];
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
        "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
        "org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
      };
    };
  };
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  programs.mosh.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  nix.settings.download-buffer-size = 524288000;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # for remaping keys
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "fjk" ];
  users.groups.input.members = [ "fjk" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
