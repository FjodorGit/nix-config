{ pkgs, inputs, ... }:
{
  imports = [ inputs.xremap.homeManagerModules.default ];

  services.gpg-agent.pinentry.package = pkgs.pinentry-gtk2;

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  services.syncthing.enable = true;

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.xremap = {
    enable = true;
    withWlroots = true;
    config.modmap = [
      {
        name = "Global";
        remap = {
          "CapsLock" = "Ctrl_L";
          "Ctrl_L" = "CapsLock";
        };
      }
    ];
  };
}
