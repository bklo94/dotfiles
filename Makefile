STOW_DIR := Linux
TARGET   := $(HOME)
PKGS     := $(notdir $(wildcard $(STOW_DIR)/*))

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

.PHONY: stow unstow restow list
