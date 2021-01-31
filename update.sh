#!/usr/bin/env bash

. ./functions.sh
. ./requirements

SUCKLESS_HOME=$HOME/Suckless

# Update system and install addational reqs if there is any
run_command "sudo apt update && sudo apt install -y $REQS" \
    "Updating system and installing new requirements"

# Update dotfiles
run_command "git clone https://github.com/gh0o5t/dotfiles.git /tmp/dotfiles" \
    "Updating dotfiles"
run_command "cp -rf /tmp/dotfiles/. $HOME/ && rm -rf /tmp/dotfiles && rm -rf $HOME/.git" \
    "Upgrading dotfiles for $USER"


# Update Suckless
if [ -d "$SUCKLESS_HOME" ]; then
   run_command "cd $SUCKLESS_HOME/dwm && git pull && make && sudo make install" \
       "Upgrading dwm"
   run_command "cd $SUCKLESS_HOME/st && git pull && make && sudo make install" \
       "Upgrading st"
   run_command "cd $SUCKLESS_HOME/dmenu && git pull && make && sudo make install" \
       "Upgrading dmenu"
   run_command "cd $SUCKLESS_HOME/dwmblocks && git pull && make && sudo make install" \
       "Upgrading dwmblocks"
   run_command "cd $SUCKLESS_HOME/slock && git pull && make && sudo make install" \
       "Upgrading slock"
fi

# Alacritty update
ALACRITTY_HOME=$HOME/Repos/dockerBuildAlacritty/
[ -d $ALACRITTY_HOME ] && cd $ALACRITTY_HOME && git pull && \
   sudo make install
   # Version change must be checked before installation

[ ! -d $ALACRITTY_HOME ] && mkdir -p $HOME/Repos && \ 
    git clone https://github.com/gh0o5t/dockerBuildAlacritty.git $ALACRITTY_HOME && \
    cd $ALACRITTY_HOME && sudo make install
