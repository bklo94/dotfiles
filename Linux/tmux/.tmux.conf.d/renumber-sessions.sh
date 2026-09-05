#!/bin/sh
# Compact numeric tmux session names (0,1,2,...) after a session closes.
# tmux has no native session renumbering (unlike renumber-windows for windows);
# wired from ~/.tmux.conf via:
#   set-hook -g session-closed 'run-shell -b ~/.tmux.conf.d/renumber-sessions.sh'
#
# - Only sessions whose name is purely numeric are renamed; named sessions are
#   left untouched (their index slot is not counted either).
# - Numeric sessions compact to 0..N-1 preserving their list order.
# - A rename that collides with an existing name fails silently and heals on
#   the next session-closed event.
# - $TMUX (set by tmux for run-shell children) routes bare `tmux` commands to
#   the server that fired the hook.
#
# NOTE: this must stay a separate file — tmux.conf expands $VAR and ${VAR} in
# every config line, so shell variables cannot survive inline in tmux.conf.

[ -n "${TMUX:-}" ] || exit 0

i=0
tmux list-sessions -F '#{session_name}' 2>/dev/null | while IFS= read -r s; do
    case $s in
        ''|*[!0-9]*) continue ;;
    esac
    if [ "$s" != "$i" ]; then
        tmux rename-session -t "=$s" "$i" 2>/dev/null || :
    fi
    i=$((i + 1))
done
