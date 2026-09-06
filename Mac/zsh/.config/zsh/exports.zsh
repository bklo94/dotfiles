# Shell environment variables. Sourced early, before oh-my-zsh.

# Editor (used by git, crontab, fzf, ^X^E, etc.)
export EDITOR=nvim
export VISUAL=nvim

# Locale — some tools warn or misbehave without it
export LANG=en_US.UTF-8

# less: quit if one screen, don't clear on exit, smart-case search
export LESS='-FRXigw'

# Coloured man pages via bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Snappier key chords; auto-report commands slower than N seconds
export KEYTIMEOUT=1
export REPORTTIME=3

# GPG
export GPG_TTY=$(tty)

# fzf: fast file/dir listing + bordered bottom popup (needs rg + fd)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'

# History (must be set before oh-my-zsh loads)
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
