#!/usr/bin/env bash

echo starting ssh server

sudo systemctl enable --now ssh
sudo systemctl status ssh
