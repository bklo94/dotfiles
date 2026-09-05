#!/bin/bash
# Regression test for tmux auto-renumbering:
#   - windows:  set-option -g renumber-windows on
#   - sessions: set-hook -g session-closed -> renumber-sessions.sh
# It sources the real lines from ~/.tmux.conf (so test and config cannot drift)
# and runs entirely on an isolated socket; your real server is never touched.
# Usage: bash ~/.tmux.conf.d/test-renumber.sh
set -u
FAIL=0
SOCKET=renumber-test
S="tmux -L $SOCKET"
CONF="${TMUX_CONF:-$HOME/.tmux.conf}"
GREP=/usr/bin/grep

check() {
  if [ "$2" = "$3" ]; then echo "PASS: $1"; else echo "FAIL: $1 — expected '$2' got '$3'"; FAIL=1; fi
}
names()  { $S list-sessions -F '#{session_name}' 2>/dev/null | tr '\n' ' ' | sed 's/ $//'; }
winidx() { $S list-windows -t "=$1" -F '#{window_index}' 2>/dev/null | tr '\n' ' ' | sed 's/ $//'; }
alive()  { $S has-session -t "=$1" 2>/dev/null; }

LIVE_BEFORE=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | tr '\n' ' ' | sed 's/ $//')

# --- Phase A: reproduce the bug (no fix loaded) ---
$S kill-server 2>/dev/null; sleep 0.5   # let a dying server release its socket
$S -f /dev/null new-session -d -s 0 2>/dev/null || { echo "FAIL: could not start scratch server"; exit 1; }
$S new-session -d -s 1 2>/dev/null; $S new-session -d -s 2 2>/dev/null
$S kill-session -t 1 2>/dev/null; sleep 0.5
check "repro: kill 1 of [0,1,2] leaves gap (bug present)" "0 2" "$(names)"

# --- Phase B: load the two fix lines straight from the real conf ---
$GREP -E '^(set-option -g renumber-windows|set-hook -g session-closed)' "$CONF" > "/tmp/renumber-test-$$.conf"
[ -s "/tmp/renumber-test-$$.conf" ] || { echo "FAIL: fix lines not found in $CONF"; exit 1; }
$S source-file "/tmp/renumber-test-$$.conf" 2>&1 || { echo "FAIL: source-file errored"; rm -f "/tmp/renumber-test-$$.conf"; exit 1; }
rm -f "/tmp/renumber-test-$$.conf"
HOOK_WANT="run-shell -b $HOME/.tmux.conf.d/renumber-sessions.sh"   # tmux tilde-expands ~ at parse time
HOOK_GOT=$($S show-hooks -g session-closed 2>/dev/null | sed 's/^session-closed\[0\] //')
check "stored hook text intact (no \$-expansion corruption)" "$HOOK_WANT" "$HOOK_GOT"
check "renumber-windows enabled" "on" "$($S show-option -gv renumber-windows 2>/dev/null)"

# --- Phase C: session gap compacts on close ---
$S kill-session -t =0 2>/dev/null; sleep 0.5   # [0,2] -> [2] -> renamed to 0
check "fix: kill 0 of [0,2] renames 2 -> 0" "0" "$(names)"

# --- Phase D: named sessions untouched, numerics compact around them ---
$S new-session -d -s work 2>/dev/null; $S new-session -d -s 7 2>/dev/null   # [0,work,7]
$S kill-session -t =0 2>/dev/null; sleep 0.5                                 # [work,7] -> 7->0
MIXED_GOT=$(names | tr ' ' '\n' | sort | tr '\n' ' ' | sed 's/ $//')
check "mixed: kill 0 of [0,work,7] gives {work,0} (order-insensitive)" "0 work" "$MIXED_GOT"
alive work && echo "PASS: named session 'work' untouched" || { echo "FAIL: 'work' clobbered"; FAIL=1; }

# --- Phase E: windows renumber ---
$S new-window -d -t =work 2>/dev/null; $S new-window -d -t =work 2>/dev/null  # windows 0,1,2
check "windows before kill" "0 1 2" "$(winidx work)"
$S kill-window -t =work:0 2>/dev/null; sleep 0.3
check "fix: kill window 0 of [0,1,2] compacts to [0,1]" "0 1" "$(winidx work)"

# --- Phase F: teardown is clean, real server untouched ---
$S kill-server 2>/dev/null
$S list-sessions >/dev/null 2>&1 && { echo "FAIL: scratch server alive after kill-server"; FAIL=1; } || echo "PASS: scratch server exited cleanly"
LIVE_AFTER=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | tr '\n' ' ' | sed 's/ $//')
check "live server untouched" "$LIVE_BEFORE" "$LIVE_AFTER"

exit $FAIL
