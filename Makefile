UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
STOW_DIR := Mac
else
STOW_DIR := Linux
endif
TARGET   := $(HOME)
# state-heavy packages kept as real dirs (not symlinked) on this machine
EXCLUDE  := qbittorrent spicetify
# directories only — trailing-slash wildcard skips README.md, packages-*.txt
PKGS     := $(filter-out $(EXCLUDE),$(notdir $(patsubst %/,%,$(wildcard $(STOW_DIR)/*/))))

# Deploy the current platform's packages: symlink ~/.config/<app> and dotfiles into this repo
stow:
	stow -d $(STOW_DIR) -t $(TARGET) $(PKGS)

unstow:
	stow -D -d $(STOW_DIR) -t $(TARGET) $(PKGS)

# Re-link after moving files between packages
restow:
	stow -R -d $(STOW_DIR) -t $(TARGET) $(PKGS)

list:
	@echo $(PKGS) | tr ' ' '\n'

# Regenerate the pacman package manifests referenced by Linux/README.md (Linux only)
packages:
	pacman -Qqen > Linux/packages-official.txt
	pacman -Qqem > Linux/packages-aur.txt

.PHONY: stow unstow restow list packages
