# ~/.zshenv — sourced by EVERY zsh (interactive, scripts, login, GUI-launched).
# Keep this minimal and side-effect-free: only environment + PATH. No output,
# no plugins, no prompts. Base PATH lives here so non-interactive shells and
# GUI apps inherit it too (interactive additions stay in ~/.zshrc).

export LANG=en_US.UTF-8

typeset -U path   # keep PATH deduped as entries are added below

# Rust (rustup) — adds ~/.cargo/bin
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Personal bin dirs
path=($HOME/bin $HOME/.local/bin $path)
