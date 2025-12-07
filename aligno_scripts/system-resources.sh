#!/usr/bin/env bash

set -e

echo Installing tmux, htop, btop, openssh-client, openssh-server, git-lfs
yes | sudo apt install tmux htop btop openssh-client openssh-server git-lfs

echo Installing ripgrep, tree, fzf, bat, eza, mc, fd-find
yes | sudo apt install ripgrep tree fzf bat eza mc fd-find

echo Installing neofetch
yes | sudo apt install neofetch

# Global Kitty "home" (mirrors ~/.local/kitty.app)
KITTY_HOME="/usr/local/share/kitty-global"
APP_DIR="$KITTY_HOME/.local/kitty.app"

# System-wide paths
BIN_DIR="/usr/local/bin"
DESKTOP_DIR="/usr/local/share/applications"
XDGT_TERMINALS="/usr/local/share/xdg-terminals.list"

echo ">>> Creating global Kitty home at $KITTY_HOME ..."
sudo mkdir -p "$KITTY_HOME"
sudo chown root:root "$KITTY_HOME"

echo ">>> Running official Kitty installer (system-wide) ..."
sudo HOME="$KITTY_HOME" sh -c \
  "curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"

# Check that installer succeeded
if [ ! -d "$APP_DIR" ]; then
  echo "ERROR: Kitty installer failed! Directory $APP_DIR does not exist."
  exit 1
fi

echo ">>> Creating system-wide symlinks in $BIN_DIR ..."
sudo ln -sf "$APP_DIR/bin/kitty" "$BIN_DIR/kitty"
sudo ln -sf "$APP_DIR/bin/kitten" "$BIN_DIR/kitten"

echo ">>> Ensuring system-wide applications directory exists ..."
sudo mkdir -p "$DESKTOP_DIR"

# Install desktop entries if they exist
for desktop_file in kitty.desktop kitty-open.desktop; do
  src="$APP_DIR/share/applications/$desktop_file"
  if [ -f "$src" ]; then
    sudo cp "$src" "$DESKTOP_DIR/"
  else
    echo "Warning: $src not found, skipping."
  fi
done

# Fix Exec and Icon paths safely
for f in "$DESKTOP_DIR"/kitty*.desktop; do
  if [ -f "$f" ]; then
    sudo sed -i "s|Exec=kitty|Exec=$BIN_DIR/kitty|g" "$f"
    sudo sed -i "s|Icon=kitty|Icon=$APP_DIR/share/icons/hicolor/256x256/apps/kitty.png|g" "$f"
  fi
done

echo ">>> Setting system-wide default terminal for xdg-terminal-exec ..."
echo 'kitty.desktop' | sudo tee "$XDGT_TERMINALS" >/dev/null

echo ""
echo "========================================================"
echo " Kitty successfully installed system-wide!"
echo " Binaries:  $BIN_DIR/kitty , $BIN_DIR/kitten"
echo " App dir:   $APP_DIR"
echo " Desktop:   $DESKTOP_DIR/kitty.desktop"
echo "========================================================"
echo ""
