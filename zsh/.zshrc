# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export LC_ALL=en_US.UTF-8

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(sudo git direnv)

source $ZSH/oh-my-zsh.sh

# Set XDG-varaibles
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state/share"
export XDG_CACHE_HOME="$HOME/.cache"

# History settings
export HISTFILE="$XDG_STATE_HOME/zsh/history"

HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
export PATH="/opt/xremap:$PATH"
export PATH="/opt/eza:$PATH"
export PATH="/opt/nvim-linux64/bin:$PATH"
export PATH="/home/fjk/neovim/bin:$PATH"
export PATH="/home/fjk/.cargo/bin:$PATH"
export PATH="/home/fjk/.local/bin:$PATH"
export PATH="/home/fjk/.ghcup/bin:$PATH"
export PATH="/home/fjk/.exercism/:$PATH"
export PATH="/home/fjk/.bazel/bin:$PATH"
export PATH="/home/fjk/.scip/bin:$PATH"
export PATH="/usr/local/pgsql/bin:$PATH"
export PATH="/home/fjk/julia/bin:$PATH"
export PATH="/opt/gurobi1100/linux64/bin:$PATH"
export PATH="/opt/gurobi952/linux64/bin:$PATH"
export PATH="/home/fjk/Coding/wabt/build:$PATH"
export PATH="/home/fjk/.gdrive:$PATH"
export PATH="/home/fjk/.geckodriver:$PATH"
export PATH="/home/fjk/.firefox:$PATH"
export PATH="/home/fjk/.chromedriver:$PATH"
export PATH="/home/fjk/.syncthing:$PATH"
export PATH="/home/fjk/Postman/:$PATH"
export PATH="/home/fjk/.local/kitty.app/bin/:$PATH"

export QT_QPA_PLATFORM=wayland
export SUDO_EDITOR="/home/fjk/neovim/bin/nvim"

export GUROBI_HOME="/opt/gurobi952/linux64"

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
export XDG_DATA_DIRS="/home/fjk/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

#Alpaca API Keys
export APCA_API_KEY_ID=PKUUBLH246T0PAIW9103

#obsidian api key
export OBSIDIAN_REST_API_KEY=3499d691621822ea827bae5de651ae78ae7cc2af4b905a007527a59311bd3168

#for editing with neovim
export VISUAL="/home/fjk/neovim/bin/nvim"
export EDITOR="/home/fjk/neovim/bin/nvim"

# for linker to find libraries
export LD_LIBRARY_PATH="/home/fjk/.scip/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="/opt/gurobi1100/linux64/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/opt/gurobi952/linux64/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/lib/gcc/x86_64-linux-gnu/11:$LD_LIBRARY_PATH"

# zoxide
export _ZO_ECHO=1

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# aliases
alias refresh="home-manager switch --flake ~/.dotfiles && source ~/.config/zsh/.zshrc"
alias rebuild="sudo nixos-rebuild switch --flake ~/.dotfiles"
alias zshconfig="nvim ~/.dotfiles/zsh/.zshrc"
alias kittyconfig="nvim ~/.dotfiles/kitty/kitty.conf"
alias homeconfig="nvim ~/.dotfiles/home.nix"
alias cat="bat"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias qn="cd ~/Documents/notes && nvim Dump.md && -"
alias notes="cd ~/Documents/notes && nvim Dump.md"
alias nvimconfig="cd ~/.dotfiles/nvim && nvim init.lua"
alias fd="fdfind"
alias ls="eza -1 -l --icons -a"
alias sups='wakeonlan -p 51821 -i 77.24.121.5 3C:EC:EF:90:A4:42'
alias tordownloads='cd /home/fjk/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/Downloads/'

################## 
# start ssh-agent automatically
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env
###################
#Calling yazi and changig cwd with yazi
function f() {
	tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# acivates starship
eval "$(starship init zsh)"

# activates zoxide
eval "$(zoxide init zsh)"

# activates fzf
source <(fzf --zsh)

#[ -f "/home/fjk/.ghcup/env" ] && source "/home/fjk/.ghcup/env" # ghcup-env

[ -f "/home/fjk/.ghcup/env" ] && source "/home/fjk/.ghcup/env" # ghcup-env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Wasmer
export WASMER_DIR="/home/fjk/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Store autocompletion data in .cache directory
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
fastfetch
