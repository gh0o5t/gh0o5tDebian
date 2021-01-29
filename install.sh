#!/usr/bin/env bash

. ./functions.sh
. ./requirements

# Install script for automating Suckless software installation and basic rice on Debian.


SUCKLESS_HOME=$HOME/Suckless

for arg in "$@"
do
    case $arg in
        # For installing docker
        "-d" )
           INSTALL_DOCKER=1;;
        # For installing alacritty
        "-a" )
           if [ "$INSTALL_DOCKER" -eq 1 ]; then
               INSTALL_ALACRITTY=1
           else
               echo "Docker installation is requierd for alacritty installation"
               exit
           fi;;
    esac
done

echo "During installation you will be prompted to provide your sudo pw."
echo "Press any key to start..."
read

# Installing requirements
run_command "sudo apt update && sudo apt install -y $REQS" \
    "Installing requirements"

# Installing and setting up fish shell for current user
run_command "sudo echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list" \
    "Adding fish shell repository"
run_command "curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null" \
    "Adding fish shell repository key"
run_command "sudo apt update && sudo apt install -y fish" \
    "Installing fish shell"
run_command "sudo usermod -s /usr/bin/fish $USER" \
    "Modifying $USER shell to fish"

# Install WiFi firmware if wireless card is available
# For this, contrib and non-free will be addedd to sources.list
#run_command "lspci | grep -i wireless && sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list \
#&& sudo apt update && sudo apt install firmware-iwlwifi && sudo modprobe -r iwlwifi ; sudo modprobe iwlwifi"

# Cloning dotfiles and copy them for current user
run_command "git clone https://github.com/gh0o5t/dotfiles.git /tmp/dotfiles" \
    "Cloning dotfiles repository"
run_command "cp -rf /tmp/dotfiles/. $HOME/ && rm -rf /tmp/dotfiles" \
    "Installing dotfiles for $USER"


# Installing Hack nerd fonts
mkdir -p ~/.local/share/fonts
run_command "cd ~/.local/share/fonts && wget 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf'" \
    "Installing Hack Regular Nerd Font"
run_command "cd ~/.local/share/fonts && wget 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Italic/complete/Hack%20Italic%20Nerd%20Font%20Complete.ttf'" \
    "Installing Hack Italic Nerd Font"
run_command "cd ~/.local/share/fonts && wget 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Bold/complete/Hack%20Bold%20Nerd%20Font%20Complete.ttf'" \
    "Installing Hack Bold Nerd Font"
run_command "cd ~/.local/share/fonts && wget 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/BoldItalic/complete/Hack%20Bold%20Italic%20Nerd%20Font%20Complete.ttf'" \
    "Installing Hack BoldItalic Nerd Font"


# Install Brave Browser
run_command "curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -" \
    "Adding Brave repository key"
run_command "echo 'deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main' | sudo tee /etc/apt/sources.list.d/brave-browser-release.list" \
    "Adding Brave repository"
run_command "sudo apt update && sudo apt install -y brave-browser" \
    "Installing Brave"

# Vim plugins
run_command "curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
    "Downloading Vim plugin manager"
#vim -c PlugInstall -c qa

# Tmux plugins
run_command "git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm" \
    "Downloading Tmux plugin manager"
#run_command "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

# Cloning and installing Suckless
run_command "mkdir $SUCKLESS_HOME" \
    "Creating Suckless home directory"
run_command "git clone https://github.com/gh0o5t/dwm.git $SUCKLESS_HOME/dwm && cd $SUCKLESS_HOME/dwm && make && sudo make install" \
    "Installing Dwm"
run_command "git clone https://github.com/gh0o5t/st.git $SUCKLESS_HOME/st && cd $SUCKLESS_HOME/st && make && sudo make install" \
    "Installing St"
run_command "git clone https://github.com/gh0o5t/dmenu.git $SUCKLESS_HOME/dmenu && cd $SUCKLESS_HOME/dmenu && make && sudo make install" \
    "Installing Dmenu"
run_command "git clone https://github.com/gh0o5t/dwmblocks.git $SUCKLESS_HOME/dwmblocks && cd $SUCKLESS_HOME/dwmblocks && make && sudo make install" \
    "Installing Dwmblocks"
run_command "git clone https://github.com/gh0o5t/slock.git $SUCKLESS_HOME/slock && cd $SUCKLESS_HOME/slock && make && sudo make install" \
    "Installing Slock"



# Installing docker and alacritty 
if [ "$INSTALL_DOCKER" -eq 1 ]; then
    run_command "curl https://raw.githubusercontent.com/gh0o5t/dockerInstallation/main/install.sh | bash" \
        "Downloading Docker installer"

    if [ "$INSTALL_ALACRITTY" -eq 1 ]; then
        run_command "mkdir -p $USER/Repos && git clone https://github.com/gh0o5t/dockerBuildAlacritty.git" \
            "Downloading Alacritty"
        run_command "cd $USER/Repos/dockerBuildAlacritty && make && sudo make install" \ 
            "Installing Alacritty"
    fi
fi



# todo 
# enable NetworkManager and remove interface from interfaces

