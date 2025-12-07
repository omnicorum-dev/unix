#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

cp ~/.zshrc "$SCRIPT_DIR/zshrc"
cp ~/.p10k.zsh "$SCRIPT_DIR/p10k.zsh"
cp ~/.tmux.conf "$SCRIPT_DIR/tmux.conf"

