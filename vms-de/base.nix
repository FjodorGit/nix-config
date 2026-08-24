{ pkgs, ... }:
let
  # Set this to your monitor's native resolution (sharp fullscreen).
  resX = 2560;
  resY = 1600;
in
{
  services.xserver.enable = true;

  services.qemuGuest.enable = true;

  # Sound stack inside the guest (PipeWire).
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors # free, x86_64-linux only
    google-chrome # unfree (needs allowUnfree above)
    # chromium                  # free alternative to chrome
  ];

  users.users.tester = {
    isNormalUser = true;
    password = "tester"; # fine for a throwaway VM
    extraGroups = [ "wheel" ];
  };

  # Applied only to the `nixos-rebuild build-vm` output.
  virtualisation.vmVariant.virtualisation = {
    memorySize = 8192;
    cores = 4;

    resolution = {
      x = resX;
      y = resY;
    };

    qemu.options = [
      "-cpu host"

      # Advertise a real mode to the (Wayland) compositor via virtio-gpu.
      # `services.xserver.resolutions` (from the resolution option above)
      # only affects Xorg; GNOME/KDE default to Wayland and ignore it.
      "-vga none"
      "-device virtio-vga,xres=${toString resX},yres=${toString resY}"

      # Sound: host backend + virtual sound card.
      # "pa" works on PulseAudio AND PipeWire hosts (via pulse compat).
      # Swap to "pipewire" for the native backend (QEMU 8.1+).
      "-audiodev pa,id=snd0"
      "-device intel-hda"
      "-device hda-output,audiodev=snd0" # use hda-duplex for mic input too
    ];
  };

  system.stateVersion = "26.11";
}
