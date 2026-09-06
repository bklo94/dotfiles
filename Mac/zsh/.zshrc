# ── Startup profiling: run `ZPROF=1 zsh` to see what's slow ─────────
[[ -n "$ZPROF" ]] && zmodload zsh/zprof

# ── Path (base PATH also set in ~/.zshenv for non-interactive shells) ─
export PATH=$HOME/bin:$HOME/.local/bin:$PATH
typeset -U path

# ── Auto-start / reattach tmux on real terminals ────────────────────
# new-session -A: attach to "main" if it exists, otherwise create it.
if [[ -z "$TMUX" && "$TERM_PROGRAM" != "vscode" && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" && -z "$INSIDE_EMACS" ]] && command -v tmux >/dev/null; then
  exec tmux new-session -A -s main
fi

# ── Environment / history (vars needed before oh-my-zsh) ────────────
[[ -r ~/.config/zsh/exports.zsh ]] && source ~/.config/zsh/exports.zsh

# ── Oh My Zsh ───────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # starship provides the prompt; no oh-my-zsh theme needed
plugins=(
  git
  extract
  zsh-autosuggestions
  fast-syntax-highlighting
  zsh-history-substring-search   # must load after syntax highlighting
  zsh-autocomplete               # load last
)
source $ZSH/oh-my-zsh.sh

unsetopt AUTO_LIST

# History: prune duplicates (oh-my-zsh only drops consecutive dups)
setopt HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
# General quality of life
setopt INTERACTIVE_COMMENTS AUTO_CD NO_BEEP NO_FLOW_CONTROL EXTENDED_GLOB
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
# Note: AUTO_CD's bare-dir-name jumps bypass the `cd=zoxide` alias, so they
# aren't recorded by zoxide. Use `cd <dir>` when you want frecency tracking.
# Word motions stop at punctuation — friendlier path editing
WORDCHARS=''

# ── Key bindings ────────────────────────────────────────────────────
bindkey -e
bindkey '^[[H'  beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
(( $+widgets[autosuggest-accept] )) && bindkey '^ ' autosuggest-accept
# up/down → history substring search (overrides zsh-autocomplete's menu
# history; comment out to restore zsh-autocomplete's up/down behaviour)
(( $+widgets[history-substring-search-up] )) && {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P'   history-substring-search-up
  bindkey '^N'   history-substring-search-down
}

# ── Tools ───────────────────────────────────────────────────────────
# kubectl completion: generate once, then read from cache
if [[ ! -r ~/.zsh/kubectl_completion.zsh ]]; then
  mkdir -p ~/.zsh
  kubectl completion zsh > ~/.zsh/kubectl_completion.zsh
fi
source ~/.zsh/kubectl_completion.zsh
alias kubectl=kubecolor
compdef kubecolor=kubectl

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
command -v fzf >/dev/null && source <(fzf --zsh)

# ── Aliases & functions ─────────────────────────────────────────────
[[ -r ~/.config/zsh/aliases.zsh ]]   && source ~/.config/zsh/aliases.zsh
[[ -r ~/.config/zsh/functions.zsh ]] && source ~/.config/zsh/functions.zsh

# ── Secrets & machine-specific overrides (in $HOME, never committed) ─
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

# ── System info on launch ───────────────────────────────────────────
command -v fastfetch >/dev/null && fastfetch

export PATH="$PATH:$HOME/.spicetify"

# ── Profiling output ────────────────────────────────────────────────
[[ -n "$ZPROF" ]] && zprof
