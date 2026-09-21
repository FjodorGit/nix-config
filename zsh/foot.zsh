# foot's pipe-* bindings hand off through FIFOs; the widgets below drain them.
# modules/home/desktop/foot.nix sets the paths it shares with those bindings,
# the defaults below keep this file usable on its own.
: ${FOOT_SCROLLBACK_FIFO:=${XDG_RUNTIME_DIR:-/tmp}/foot-scrollback.fifo}
: ${FOOT_OUTPUT_FIFO:=${XDG_RUNTIME_DIR:-/tmp}/foot-command-output.fifo}

# On tmpfs, so recreate them per session.
for _f in "$FOOT_SCROLLBACK_FIFO" "$FOOT_OUTPUT_FIFO"; do
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
# SIGINT, so the timeout has to sit on the drain. term-nvim takes it from
# there, keyed by TERM_NVIM_MODE.
_foot-scrollback-nvim() {
  local -x NVIM_APPNAME=term-nvim TERM_NVIM_MODE=$1
  nvim -R - < <(timeout 5 cat "$FOOT_SCROLLBACK_FIFO")
  zle reset-prompt
}

foot-scrollback-nvim() { _foot-scrollback-nvim scrollback }
foot-scrollback-with-search-nvim() { _foot-scrollback-nvim scrollback-search }

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
  { print -r -- "$cmd"; timeout 5 cat "$FOOT_OUTPUT_FIFO" } | wl-copy
  zle -M "yanked: ${cmd[1,60]}"
  exec {fd}< <(sleep 0.33)
  zle -F $fd _foot-yank-clear
}

foot-yank-command-line() {
  print -rn -- "$BUFFER" | wl-copy
}

zle -N foot-scrollback-nvim
zle -N foot-scrollback-with-search-nvim
zle -N foot-yank-command-output
zle -N foot-yank-command-line
bindkey '^X^L' foot-scrollback-nvim
bindkey '^X^P' foot-scrollback-with-search-nvim
bindkey '^X^Y' foot-yank-command-output
bindkey '^X^V' foot-yank-command-line
