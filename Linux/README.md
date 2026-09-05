# Linux setup

Arch + Hyprland dotfiles, managed with [GNU stow](https://www.gnu.org/software/stow/).
Each directory under `Linux/` is a stow package: `Linux/<pkg>/.config/<app>` (or a
dotfile like `zsh/.zshrc`). Bootstrapping a fresh machine is the sequence below.

## 1. Bootstrap

```bash
# minimal tooling, then clone anywhere (convention: ~/Github/dotfiles)
sudo pacman -S --needed git stow make
git clone git@github.com:bklo94/dotfiles.git ~/Github/dotfiles
cd ~/Github/dotfiles && make stow        # symlinks ~/.config/<app>, ~/.zshrc, ...
```

Pre-stow leftovers on the new machine (e.g. a stock `~/.zshrc`) will conflict —
move them aside first: `mv ~/.zshrc ~/.zshrc.orig` (same for any `~/.config/<app>`
that is also a package). `make unstow` / `make restow` undo/redo links.

## 2. Packages

Explicitly installed packages, split by origin (regenerate with `make packages`):

```bash
# official repos (115)
sudo pacman -S --needed - < packages-official.txt
# AUR (23) — needs yay first
yay -S --needed - < packages-aur.txt
```

Full lists: [packages-official.txt](packages-official.txt) · [packages-aur.txt](packages-aur.txt)

<details><summary>Official packages (115)</summary>

```
7zip
amd-ucode
argocd
base
base-devel
bat
bind
bitwarden
btop
chromium
cliphist
cpio
cronie
cups
cups-filters
dhclient
difftastic
discord
docker
duf
dust
efibootmgr
etcd
eza
fastfetch
fd
gdb
ghostscript
ghostty
git
grub
hyperfine
hyprcursor
hyprgraphics
hypridle
hyprland
hyprland-guiutils
hyprpaper
hyprpolkitagent
hyprshot
hyprwayland-scanner
istio
jq
k9s
kitty
kubectl
kubectx
lazydocker
lib32-glibc
libfido2
libva-utils
linux
linux-firmware
linux-lts
mako
man-db
mesa-utils
mpv
nano
navi
ncdu
ncspot
neovim
networkmanager
nikto
nmap
noto-fonts-cjk
npm
nss-mdns
ntfs-3g
openssh
os-prober
pacman-contrib
pavucontrol
pipewire
pipewire-pulse
procs
python-pip
qt5-quickcontrols2
qt6-virtualkeyboard
reflector
sbctl
scrot
sd
sddm
smartmontools
spotify-launcher
sqlitebrowser
starship
stow
talosctl
tekton-cli
tmux
traceroute
tree
trivy
ufw
unp
usbguard
util-linux
uv
uwsm
vim
vulkan-radeon
waybar
webkit2gtk-4.1
wget
wofi
xdg-desktop-portal-hyprland
xdotool
yazi
yubico-pam
yubikey-manager
zoxide
zsh
```
</details>

<details><summary>AUR packages (23)</summary>

```
apple-fonts
archey4
bottom-git
brother-dcp-l2540dw-cups-bin
brother-dcp-l2540dw-lpr-bin
bun-bin
flux-bin
gnu-netcat
htpasswd
hyprsysteminfo
jdbrowser-git
kubecolor
lightscreen
microsoft-edge-stable-bin
neofetch
outfieldr
rustdesk
smassh-bin
spaceship-prompt
vscodium-bin
wlogout
yay
zen-browser-bin
```
</details>

## 3. Not from pacman

```bash
# oh-my-zsh + custom plugins (zshrc expects these)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions   ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autocomplete      ~/.oh-my-zsh/custom/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# then inside tmux: prefix + I   (installs plugins from .tmux.conf)

# bun (package manager for TS/JS)
curl -fsSL https://bun.sh/install | bash

# Proton Pass CLI (https://protonpass.github.io/pass-cli/) — secrets via `pass-agent`

# Proton Pass SSH agent — unit is stowed by `make stow`; enable once per machine
systemctl --user enable --now proton-pass-ssh-agent.service
```

## 4. Secrets & keys (manual, never in this repo)

- `~/.secrets.zsh` — sourced by `.zshrc` (env credentials)
- `~/.claude/settings.json` — copy from `claude/.claude/settings.json.example`
  and fill `env` values (API tokens). The real file is gitignored.
  **Full version in Proton Pass** (Personal vault): item `claude-settings.json (bklo workstation)`
- `~/.ssh/` keys + `config` — `ssh/.ssh/config.example` is a template (this repo
  is public; keep real host entries local). **Real config in Proton Pass**
  (Personal vault): item `ssh-config (bklo workstation)` — restore with
  `pass-cli item view --vault-name Personal --item-title 'ssh-config (bklo workstation)' --field note > ~/.ssh/config`. SSH keys live in Proton Pass as
  SSH-key items; the systemd agent serves them and `.zshrc` points
  `SSH_AUTH_SOCK` at it, so `~/.ssh` private keys are optional (keep `.pub`s).
  Add new keys with the `pp-ssh-add <key>` zsh function (imports to the
  Homelab vault and restarts the agent; tested by `tests/pp-ssh-add-test.zsh`)
- `~/.config/pass-cli/agent-claude-code.env` — PAT session env for the
  `claude-code` pass-cli agent (chmod 600, never in repo); created via
  `pass-cli agent create`, wrapped by `bin/.local/bin/pass-agent`
- `~/.claude.json` (Claude Code app state) — `mcpServers` template at
  `claude/.claude/mcp-servers.example.json`; the z.ai key lives in
  `~/.secrets.zsh` and is wired in via `${Z_AI_API_KEY}` expansion
  (both `env` and the `Authorization: Bearer` header)
- GPG: import signing key `6D872D6B1FF171D5CD16B634BAED9238E5F45E7C`
  (`.gitconfig` signs all commits/tags)
- Git credentials: first HTTPS push prompts once (`credential.helper=store`)

## Packages overview

| Package | Contents |
|---|---|
| bat, btop, fastfetch, ghostty, k9s, nvim, pnpm, spotify-player, starship, waybar, wofi | `~/.config/<app>` |
| git | `~/.gitconfig`, `~/.config/git/ignore` |
| hypr | Hyprland **Lua** config (`hyprland.lua`), windowrules, hyprpaper |
| zsh | `~/.zshrc` (oh-my-zsh + plugins above) |
| tmux | `~/.tmux.conf` (tpm) |
| claude | `~/.claude/` — CLAUDE.md, agents, skills, hooks, settings + MCP-server templates |
| ssh | `~/.ssh/allowed_signers` + `config.example` (template only) |
| systemd | `~/.config/systemd/user/` — Proton Pass SSH agent unit |
| bin | `~/.local/bin/pass-agent` — scoped pass-cli wrapper for agents |
