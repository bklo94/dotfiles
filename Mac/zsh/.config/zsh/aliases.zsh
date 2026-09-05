# Aliases. Sourced after tools so zoxide's `z` exists for the `cd` alias.

# Editors
alias vi="nvim"
alias vim="nvim"

# Listing (eza)
alias ls="eza --long --color=always --icons=always --no-user"
alias ll="eza --long --git --icons"
alias la="eza --long --all --git --icons"
alias lt="eza --tree --level=2 --git-ignore"

# Navigation. `cd` routes through zoxide; parent hops use the builtin directly
# (zoxide's `z` doesn't resolve relative paths like `..`).
alias cd="z"
alias ..='builtin cd ..'
alias ...='builtin cd ../..'
alias ....='builtin cd ../../..'

# Misc
alias cat="bat"
alias mkdir="mkdir -p"
alias grep="grep --color=auto"
alias reload="exec zsh"
alias brewup="brew update && brew upgrade && brew cleanup"
alias dh='dirs -v'                 # browse the directory stack (AUTO_PUSHD)
alias del='trash'                  # non-destructive delete (trash is installed)

# macOS
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles false && killall Finder'
alias odb='open -R'                # reveal the selected file in Finder
