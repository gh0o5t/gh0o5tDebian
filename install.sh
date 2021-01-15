#!/usr/bin/env bash

# Install script for automating Suckless software installation and basic rice on Debian.


SUCKLESS_HOME=$HOME/Suckless

REQS="apt-transport-https curl gnupg git wget build-essential xorg xinput x11-xserver-utils libxcursor-dev libxrandr-dev libxi-dev libimlib2-dev libxft-dev libfontconfig1 libx11-6 libxinerama-dev xserver-xorg-dev \
compton vim vim-gtk pcmanfm arandr lxappearance htop ranger tmux qt5ct feh firefox-esr pulseaudio pasystray pavucontrol pulsemixer pulseaudio-module-bluetooth  network-manager dunst locate zathura sxiv scrot neofetch blueman" 

check_command(){
    if [ $? -ne 0 ]; then
        echo "$1"
        echo "Installation is not completed"  
        echo "Press any key to close..."  
        read
        exit
    fi
}

run_command() {
    echo -e "Executing: $1\n"
    eval $1 &>/dev/null && sleep 3
    check_command "$1 execution failed"
}

echo "During installation you will be prompted to provide your sudo pw."
echo "Dotfiles will be installed only for the user."
echo "Press any key to start..."
read

# Installing requirements
sudo apt update && sudo apt install -y $REQS
check_command "Installation of requirements failed"

# Installing and setting up fish shell for current user
run_command "sudo echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list"
run_command "curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null"
sudo apt update && sudo apt install -y fish
check_command "Installation of fish failed"
run_command "sudo chsh -s `which fish`"

# Install WiFi firmware if wireless card is available
# For this, contrib and non-free will be addedd to sources.list
run_command "lspci | grep -i wireless && sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list \
&& sudo apt update && sudo apt install firmware-iwlwifi && sudo modprobe -r iwlwifi ; sudo modprobe iwlwifi"

# Cloning dotfiles and copy them for current user
run_command "git clone https://github.com/gh0o5t/dotfiles.git /tmp/dotfiles"
run_command "cp -rf /tmp/dotfiles/. $HOME/ && rm -rf /tmp/dotfiles"

# Linking themes and icons because they don not work at the expected location
ln -sf ~/.local/share/icons ~/.icons
ln -sf ~/.local/share/themes ~/.themes

# Install Brave Browser
run_command "curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -"
run_command "echo 'deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main' | sudo tee /etc/apt/sources.list.d/brave-browser-release.list"
sudo apt update && sudo apt install -y brave-browser
check_command "Installation of brave browser failed"

# Vim plugins
run_command "curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
#vim -c PlugInstall -c qa

# Tmux plugins
run_command "git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"
#run_command "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

# Cloning and installing Suckless
run_command "mkdir $SUCKLESS_HOME"
run_command "git clone https://github.com/gh0o5t/dwm.git $SUCKLESS_HOME/dwm && cd $SUCKLESS_HOME/dwm && make && sudo make install"
run_command "git clone https://github.com/gh0o5t/st.git $SUCKLESS_HOME/st && cd $SUCKLESS_HOME/st && make && sudo make install"
run_command "git clone https://github.com/gh0o5t/dmenu.git $SUCKLESS_HOME/dmenu && cd $SUCKLESS_HOME/dmenu && make && sudo make install"
run_command "git clone https://github.com/gh0o5t/dwmblocks.git $SUCKLESS_HOME/dwmblocks && cd $SUCKLESS_HOME/dwmblocks && make && sudo make install"
run_command "git clone https://github.com/gh0o5t/slock.git $SUCKLESS_HOME/slock && cd $SUCKLESS_HOME/slock && make && sudo make install"

