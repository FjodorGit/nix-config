{
  ...
}:
let
  # Shared by foot's pipe-* bindings and the zsh widgets below.
  fifo = name: "\${XDG_RUNTIME_DIR:-/tmp}/foot-${name}.fifo";
  scrollbackFifo = fifo "scrollback";
  outputFifo = fifo "command-output";
in
{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        dpi-aware = "yes";
        font = "Iosevka Nerd Font:size=8";
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
      };
    };
  };

  programs.zsh.initContent = ''
    # foot's pipe-* bindings hand off through FIFOs. On tmpfs, so recreate
    # them per session.
    for _f in "${scrollbackFifo}" "${outputFifo}"; do
      [[ -p $_f ]] || { command rm -f $_f; command mkfifo $_f }
    done
    unset _f

    # Marks where command output starts/ends; without it foot can't find it.
    # $history is shared between shells (SHARE_HISTORY), so keep our own.
    autoload -Uz add-zsh-hook
    _foot_preexec() { _foot_last_command=$1; print -n '\e]133;C\e\\' }
    _foot_precmd() { print -n '\e]133;D\e\\' }
    add-zsh-hook preexec _foot_preexec
    add-zsh-hook precmd _foot_precmd

    # Via stdin, not `nvim -R <fifo>`: nvim blocked on a FIFO open ignores
    # SIGINT, so the timeout has to sit on the drain. Extra args must drive
    # nvim through feedkeys -- `-c` runs before VimEnter, where term-nvim
    # puts the cursor on the newest line.
    _foot-scrollback-nvim() {
      local -x NVIM_APPNAME=term-nvim TERM_NVIM_MODE=scrollback
      nvim -R "$@" - < <(timeout 5 cat "${scrollbackFifo}")
      zle reset-prompt
    }

    foot-scrollback-nvim() { _foot-scrollback-nvim }
    foot-scrollback-with-search-nvim() {
      _foot-scrollback-nvim -c 'call feedkeys("?", "n")'
    }

    # Woken when the sleep below exits and closes its pipe.
    _foot-yank-clear() {
      local fd=$1
      zle -F $fd
      exec {fd}<&-
      zle -M ""
      zle -R
    }

    foot-yank-command-output() {
      local cmd=$_foot_last_command fd
      { print -r -- "$cmd"; timeout 5 cat "${outputFifo}" } | wl-copy
      zle -M "yanked: ''${cmd[1,60]}"
      exec {fd}< <(sleep 0.25)
      zle -F $fd _foot-yank-clear
    }

    zle -N foot-scrollback-nvim
    zle -N foot-scrollback-with-search-nvim
    zle -N foot-yank-command-output
    bindkey '^X^L' foot-scrollback-nvim
    bindkey '^X^P' foot-scrollback-with-search-nvim
    bindkey '^X^Y' foot-yank-command-output
  '';
}
