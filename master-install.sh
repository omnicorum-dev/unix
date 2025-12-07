#!/usr/bin/env bash

echo $SHELL

SCRIPTS="aligno_scripts"

source $SCRIPTS/build-essentials.sh
source $SCRIPTS/system-resources.sh
source $SCRIPTS/python.sh
sudo $SCRIPTS/create-users.sh
source $SCRIPTS/neovim-setup.sh
sudo $SCRIPTS/zsh-setup.sh

