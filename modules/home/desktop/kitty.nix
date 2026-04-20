{
  ...
}:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };

    themeFile = "Catppuccin-Mocha";

    shellIntegration.enableZshIntegration = true;

    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      paste_actions = "quote-urls-at-prompt";
      enable_audio_bell = "no";

      remember_window_size = "yes";
      initial_window_width = 640;
      initial_window_height = 400;

      enabled_layouts = "tall,stack,horizontal,splits";
      window_border_width = 0;
      draw_minimal_borders = "yes";
      active_border_color = "#ffffff";
      inactive_text_alpha = "0.7";
      hide_window_decorations = "yes";
      confirm_os_window_close = 2;

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      allow_hyperlinks = "yes";
    };

    keybindings = {
      # Tab management
      "ctrl+a>n" = "previous_tab";
      "ctrl+a>p" = "next_tab";
      "ctrl+a>enter" = "new_tab";
      "ctrl+a>x" = "close_tab";

      # Window management
      "ctrl+l" = "next_window";
      "ctrl+h" = "previous_window";
      "ctrl+a>k" = "first_window";
      "ctrl+a>j" = "second_window";
      "ctrl+a>l" = "third_window";
      "ctrl+x" = "close_window";
      "ctrl+a>m" = "toggle_layout stack";
      "ctrl+a>v" = "new_window_with_cwd";

      # Open scrollback buffer in nvim
      "ctrl+a>[" = ''launch --env NVIM_APPNAME=ksb-nvim --type=overlay --stdin-source=@screen_scrollback sh -c 'KITTY_SOURCE_WID="$0" exec nvim' @active-kitty-window-id'';
    };
  };
}
