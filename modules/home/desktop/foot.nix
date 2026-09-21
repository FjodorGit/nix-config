{
  config,
  dotfilesDir,
  ...
}:
let
  # Shared by foot's pipe-* bindings and the zsh widgets in zsh/foot.zsh.
  fifo = name: "\${XDG_RUNTIME_DIR:-/tmp}/foot-${name}.fifo";
  scrollbackFifo = fifo "scrollback";
  outputFifo = fifo "command-output";
in
{
  home.file.".config/zsh/foot.zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zsh/foot.zsh";
  };

  programs.foot = {
    enable = true;

    settings = {
      main = {
        dpi-aware = "no";
        font = "IosevkaTerm Nerd Font:size=15";
        term = "xterm-256color";
      };

      security.osc52 = "enabled";
      bell.system = "no";

      scrollback = {
        lines = 10000;
        multiplier = 5.0;
      };

      url.osc8-underline = "always";

      cursor.blink = "yes";

      mouse.hide-when-typing = "yes";

      csd.preferred = "none";

      key-bindings = {
        # `tee`, not `cat >`: a shell redirect blocks before timeout can start.
        pipe-scrollback = [
          ''[sh -c "timeout 5 tee ${scrollbackFifo} >/dev/null"] Control+Shift+b''
        ];
        # Spans OSC 133 C..D, so output only; the widget prepends the command.
        pipe-command-output = [
          ''[sh -c "timeout 5 tee ${outputFifo} >/dev/null"] Control+Shift+y''
        ];
        spawn-terminal = [ "Control+Shift+t" ];
      };
    };
  };

  programs.zsh.initContent = ''
    typeset -g FOOT_SCROLLBACK_FIFO="${scrollbackFifo}" FOOT_OUTPUT_FIFO="${outputFifo}"
    [[ -f ~/.config/zsh/foot.zsh ]] && source ~/.config/zsh/foot.zsh
  '';
}
