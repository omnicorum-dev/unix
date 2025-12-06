#!/usr/bin/env bash

echo Installing tmux, htop, btop, openssh-client, openssh-server, git-lfs
yes | sudo apt install tmux htop btop openssh-client openssh-server git-lfs

echo Installing ripgrep, tree, fzf, bat, eza, mc
yes | sudo apt install ripgrep tree fzf bat eza mc

