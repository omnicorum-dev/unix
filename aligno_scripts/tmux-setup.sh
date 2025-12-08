#!/usr/bin/env bash

mkdir -p /etc/tmux
mkdir -p /etc/tmux-plugins

#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm /etc/tmux-plugins/tpm

DEFAULT_TCONF="/etc/tmux/tmux.conf"
SCRIPT_DIR=$(dirname "$(realpath "$0")")

cp "$SCRIPT_DIR/tmux.conf" $DEFAULT_TCONF

echo "Applying default .tmux.conf to all users"

for home in /home/*; do
  if [ -d "$home" ]; then
    cp "$DEFAULT_TCONF" "$home/.tmux.conf"
    chown $(basename "$home"):$(basename "$home") "$home/.tmux.conf"
  fi
done
