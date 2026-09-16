{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  niriMsg = args: {
    launch = [
      "${config.programs.niri.package}/bin/niri"
      "msg"
      "action"
    ]
    ++ args;
  };
in
{
  imports = [ inputs.xremap.homeManagerModules.default ];

  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

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
                "l" = niriMsg [
                  "switch-layout"
                  "next"
                ];
              };
              timeout_millis = 500;
            };
          };
        }
        {
          # foot has no native key chords, so xremap turns Ctrl-a into a leader.
          name = "Foot chords";
          application.only = [ "foot" ];
          remap = {
            "Ctrl-a" = {
              remap = {
                # Dump the scrollback (foot), then drain it into nvim (zsh).
                # No delay needed: the FIFO open is the synchronisation.
                "u" = [
                  "Ctrl-Shift-b"
                  "Ctrl-x"
                  "Ctrl-l"
                ];
                "SLASH" = [
                  "Ctrl-Shift-b"
                  "Ctrl-x"
                  "Ctrl-p"
                ];
                "y" = [
                  "Ctrl-Shift-y"
                  "Ctrl-x"
                  "Ctrl-y"
                ]; # yank last command + its output
                "LEFTBRACE" = [
                  "Ctrl-x"
                  "Ctrl-e"
                ]; # zsh edit-command-line
              };
              timeout_millis = 500;
              # Drop the leader on timeout instead of emitting a stray "a".
              timeout_key = [ ];
            };
          };
        }
      ];
    };
  };
}
