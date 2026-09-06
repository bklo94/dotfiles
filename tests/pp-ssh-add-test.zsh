#!/usr/bin/env zsh
# Behavioral test for the pp-ssh-add function in Linux/zsh/.zshrc.
# Stubs pass-cli + systemctl — touches nothing real (no Proton session, no unit).
# Run from anywhere: zsh tests/pp-ssh-add-test.zsh   (exit 0 = all pass)
# It reads ~/.zshrc (the stowed symlink), so it tests the shipped file, not a copy.
set -u
fail=0
check() { # label expected actual
  if [[ "$2" == "$3" ]]; then echo "PASS: $1"; else echo "FAIL: $1 — expected [$2] got [$3]"; fail=1; fi
}

stubdir=$(mktemp -d)
export PATH=$stubdir:$PATH

# stub pass-cli: logs args, exit code controllable via $STUB_RC
cat > $stubdir/pass-cli <<'EOF'
#!/usr/bin/env sh
printf '%s\n' "$*" >> "$(dirname "$0")/args.log"
exit "${STUB_RC:-0}"
EOF
# stub systemctl: logs args
cat > $stubdir/systemctl <<'EOF'
#!/usr/bin/env sh
printf '%s\n' "$*" >> "$(dirname "$0")/systemctl.log"
EOF
chmod +x $stubdir/pass-cli $stubdir/systemctl

eval "$(awk '/^pp-ssh-add\(\)/,/^}$/' ~/.zshrc)"

keyfile=$(mktemp)
bn=$(basename $keyfile)

# 1. normal invocation → exact argv passed to pass-cli
pp-ssh-add $keyfile >/dev/null
check "argv" "item create ssh-key import --from-private-key $keyfile --title $bn --vault-name Homelab" "$(cat $stubdir/args.log)"

# 2. agent is restarted after a successful import
check "restart-on-success" "--user restart proton-pass-ssh-agent.service" "$(cat $stubdir/systemctl.log)"

# 3. .pub path tolerated (stripped)
: > $stubdir/args.log
pp-ssh-add $keyfile.pub >/dev/null
check "pub-strip" "item create ssh-key import --from-private-key $keyfile --title $bn --vault-name Homelab" "$(cat $stubdir/args.log)"

# 4. vault override
: > $stubdir/args.log
pp-ssh-add $keyfile Personal >/dev/null
check "custom-vault" "item create ssh-key import --from-private-key $keyfile --title $bn --vault-name Personal" "$(cat $stubdir/args.log)"

# 5. missing arg → rc 2
pp-ssh-add 2>/dev/null
check "no-arg-rc" "2" "$?"

# 6. nonexistent file → rc 1
pp-ssh-add /nonexistent/key 2>/dev/null
check "bad-file-rc" "1" "$?"

# 7. failed import → non-zero rc AND no agent restart
: > $stubdir/args.log; : > $stubdir/systemctl.log
STUB_RC=1 pp-ssh-add $keyfile >/dev/null 2>&1
check "import-fail-rc" "1" "$?"
check "no-restart-on-fail" "" "$(cat $stubdir/systemctl.log)"

rm -rf $stubdir $keyfile
exit $fail
