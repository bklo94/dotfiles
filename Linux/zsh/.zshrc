# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:/home/bklo/.bun/bin:$PATH
if [ "$TMUX" = "" ]; then tmux; fi
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export GPG_TTY=$(tty)
export EDITOR=nvim
unsetopt AUTO_LIST

setopt inc_append_history hist_expire_dups_first hist_ignore_space
HISTFILE=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h
SAVEHIST=99999999 # History file size
HISTSIZE=99999999   # Session history size
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY
setopt auto_cd
setopt share_history

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh
#source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
#source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

if [ -z "$DISABLE_ZOXIDE" ]; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vi="nvim"
alias vim="nvim"
alias ls="eza --long --color=always --icons=always --no-user"
alias cd="z"
alias cat="bat"
alias find="fd"
alias df="duf"
alias du="dust"
alias unzip="unp"
alias ff="fastfetch"
alias sed="sd"
alias man="tldr"
alias diff="difft"
alias tt="smassh"
alias talswitcher="talswitcher context --talosconfig-dir ~/.talos/configs/"
alias ccusage="bunx better-ccusage"

#autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit -C
source <(kubectl completion zsh)
alias kubectl=kubecolor
compdef kubecolor=kubectl
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
#fastfetch

# opencode
export PATH=/home/bklo/.opencode/bin:$PATH

# bun completions
[ -s "/home/bklo/.bun/_bun" ] && source "/home/bklo/.bun/_bun"

# Added by sonarqube-cli installer
export PATH="$HOME/.local/share/sonarqube-cli/bin:$PATH"

# Source secrets (env-based credentials, e.g. SonarQube CLI token)
[ -f "$HOME/.secrets.zsh" ] && source "$HOME/.secrets.zsh"

# Proton Pass SSH agent — serves SSH keys from the Homelab vault
# (daemon managed by systemd user unit: proton-pass-ssh-agent.service)
export SSH_AUTH_SOCK="$HOME/.ssh/proton-pass-agent.sock"

# Durable ssh-add: import a key into Proton Pass (default: Homelab vault).
# The daemon loads its key set at startup (--refresh-interval does NOT pick up
# new items), so this restarts the unit after importing — keys serve again in
# ~15s. (ssh-add itself can't upload to the Proton agent; it only lists with -l.)
pp-ssh-add() {
  emulate -L zsh
  local key="${1-}" vault="${2:-Homelab}"
  key="${key%.pub}"
  if [[ -z "$key" ]]; then
    echo "usage: pp-ssh-add <private-key-path> [vault-name]" >&2
    return 2
  fi
  if [[ ! -f "$key" ]]; then
    echo "pp-ssh-add: no such file: $key" >&2
    return 1
  fi
  pass-cli item create ssh-key import --from-private-key "$key" --title "$(basename "$key")" --vault-name "$vault" \
    && systemctl --user restart proton-pass-ssh-agent.service \
    && echo "imported to '$vault', agent restarting — ready in ~15s, then: ssh-add -l"
}
