#!/usr/bin/env bash

echo "$SHELL"

SCRIPTS="aligno_scripts"

source $SCRIPTS/build-essentials.sh
source $SCRIPTS/system-resources.sh
source $SCRIPTS/python.sh
sudo $SCRIPTS/create-users.sh
sudo $SCRIPTS/neovim-setup.sh
sudo $SCRIPTS/zsh-setup.sh
sudo $SCRIPTS/tmux-setup.sh
source $SCRIPTS/yazi-setup.sh
source $SCRIPTS/start-ssh.sh

source "post-install-instructions.sh"
