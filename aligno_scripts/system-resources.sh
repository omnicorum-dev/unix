#!/usr/bin/env bash

echo Installing tmux, htop, btop, openssh-client, openssh-server, git-lfs
yes | sudo apt install tmux htop btop openssh-client openssh-server git-lfs

echo Installing ripgrep, tree, fzf, bat, eza, mc, fd-find
yes | sudo apt install ripgrep tree fzf bat eza mc fd-find

echo Installing neofetch 
yes | sudo apt install neofetch

echo Installing kitty terminal
KITTY_DIR="/opt/kitty"
sudo rm -rf "$KITTY_DIR"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sudo sh /dev/stdin

# The installer by default puts kitty in ~/.local/kitty.app
# Move it to /opt for system-wide usage
sudo mv ~/.local/kitty.app "$KITTY_DIR"

# -------------------------------
# Step 2: Symlink kitty and kitten to /usr/local/bin
# -------------------------------
sudo ln -sf "$KITTY_DIR/bin/kitty" /usr/local/bin/kitty
sudo ln -sf "$KITTY_DIR/bin/kitten" /usr/local/bin/kitten

# -------------------------------
# Step 3: Install desktop entries globally
# -------------------------------
sudo cp "$KITTY_DIR/share/applications/kitty.desktop" /usr/share/applications/
sudo cp "$KITTY_DIR/share/applications/kitty-open.desktop" /usr/share/applications/

# Update Exec and Icon paths in desktop files
sudo sed -i "s|Exec=kitty|Exec=$KITTY_DIR/bin/kitty|g" /usr/share/applications/kitty*.desktop
sudo sed -i "s|Icon=kitty|Icon=$KITTY_DIR/share/icons/hicolor/256x256/apps/kitty.png|g" /usr/share/applications/kitty*.desktop
