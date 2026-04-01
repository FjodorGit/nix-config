{ config, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
in
{
  programs.zellij = {
    enable = true;

    settings = {
      # Invisible UI
      pane_frames = false;
      default_layout = "minimal";

      # Locked mode: all keys pass through to the shell by default.
      # Unlock with Ctrl+g to access zellij commands.
      default_mode = "locked";

      # Session persistence across disconnects and reboots
      session_serialization = true;
      serialize_pane_viewport = true;

      # When SSH drops or kitty closes, detach instead of killing
      on_force_close = "detach";

      # Disable features you won't use
      mouse_mode = false;
      scroll_buffer_size = 50000;

      # Simplified UI when you do need it (no special font glyphs)
      simplified_ui = true;
    };

    # A bare layout with no bars, no plugins — just a shell
    layouts = {
      minimal = {
        layout = {
          pane = { };
        };
      };
    };
  };
}
