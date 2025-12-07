#!/usr/bin/env bash

mkdir -p /etc/tmux

DEFAULT_TCONF="/etc/tmux/tmux.conf"
SCRIPT_DIR=$(dirname "$(realpath "$0")")

echo "Applying default .tmux.conf to all users"

for home in /home/*; do
	if [ -d "$home" ]; then
		cp "$DEFAULT_TCONF" "$home/.tmux.conf"
		chown $(basename "$home"):$(basename "$home") "$home/.tmux.conf"
	fi
done

