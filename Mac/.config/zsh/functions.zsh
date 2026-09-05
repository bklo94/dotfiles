# Shell functions. Sourced after tools so builtins behave as expected.

# Create a directory and enter it (builtin cd bypasses the zoxide alias,
# which wouldn't find a brand-new dir in its frecency database).
mkcd() { mkdir -p "$1" && builtin cd "$1"; }

# cd into the front Finder window.
cdf() {
  local target
  target=$(osascript -e 'tell application "Finder" to get POSIX path of (target of front window as alias)' 2>/dev/null) || return
  [[ -n "$target" ]] && builtin cd "$target" || echo "cdf: no Finder window" >&2
}
