#!/usr/bin/env bash

echo Installing build-essential, cmake, curl, and vim
yes | sudo apt install build-essential
yes | sudo apt install cmake curl
yes | sudo apt install vim

echo Installing manpages-dev, pkg-config, software-properties-common
yes | sudo apt install manpages-dev pkg-config software-properties-common

echo Installing gdb, strace, lsof, net-tools
yes | sudo apt install gdb strace lsof net-tools

echo Installing cscope, cmatrix
yes | sudo apt install cscope cmatrix

echo Installing nmap, netcat-traditional
yes | sudo apt install nmap netcat-traditional

