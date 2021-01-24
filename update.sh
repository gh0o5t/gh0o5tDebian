#!/usr/bin/env bash

. ./functions.sh

SUCKLESS_HOME=$HOME/Suckless

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
