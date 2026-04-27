{
  pkgs,
  inputs,
  lib,
  ...
}:
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
    withNiri = true;
    config = {
      modmap = [
        {
          name = "Global";
          remap = {
            "CapsLock" = "Ctrl_L";
            "Ctrl_L" = "CapsLock";
          };
        }
      ];
      keymap = [
        {
          name = "Launcher";
          remap = {
            "Alt-space" = {
              remap = {
                "c" = {
                  launch = [
                    "${lib.getExe pkgs.kitty}"
                    "${lib.getExe pkgs.sage}"
                  ];
                };
              };
              timeout_millis = 500;
            };
          };
        }
      ];
    };
  };
}
