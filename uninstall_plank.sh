#!/bin/bash

sudo pkill -9 "^plank$"
sudo apt purge plank -y
rm -rfv $HOME/.config/plank/
rm -rfv $HOME/.local/share/plank
rm -rfv /var/tmp/plankThemeInstall/



