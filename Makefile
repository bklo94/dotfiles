STOW_DIR := Linux
TARGET   := $(HOME)
# directories only — trailing-slash wildcard skips README.md, packages-*.txt
PKGS     := $(notdir $(patsubst %/,%,$(wildcard $(STOW_DIR)/*/)))

# Deploy all Linux packages: symlink ~/.config/<app> and ~/.zshrc into this repo
stow:
	stow -d $(STOW_DIR) -t $(TARGET) $(PKGS)

unstow:
	stow -D -d $(STOW_DIR) -t $(TARGET) $(PKGS)

# Re-link after moving files between packages
restow:
	stow -R -d $(STOW_DIR) -t $(TARGET) $(PKGS)

list:
	@echo $(PKGS) | tr ' ' '\n'

# Regenerate the pacman package manifests referenced by Linux/README.md
packages:
	pacman -Qqen > $(STOW_DIR)/packages-official.txt
	pacman -Qqem > $(STOW_DIR)/packages-aur.txt

.PHONY: stow unstow restow list packages
