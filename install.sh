#!/bin/bash

INSTALL="sudo pacman -S --noconfirm --needed"
DOTFILES_REPO_PATH="/tmp/dotfiles"

function echo_colour()
{
    str=""
    case "$2" in
        "g") str+="\033[32m" ;;
        "y") str+="\033[31m" ;;
        "r") str+="\033[33m" ;;
    esac
    str+="$1\033[0m"
    echo -e $str
}

function install()
{
    echo_colour "[+] Installing $1" "g"
    local install_out=$($INSTALL $1 2>&1)
    local installed_str="there is nothing to do"
    if [[ $install_out =~ $installed ]];
    then
        echo_colour "[*] $1 already installed" "y"
    fi

}

# Core
install git
install picom
install rofi

# Misc
install flameshot

# Clone repo and move files
echo_colour "[+] Downloading files" "g"
git clone --depth 1 https://github.com/TaconeoMental/dotfiles $DOTFILES_REPO_PATH
tar -c --exclude .git --exclude README.md --exclude install.sh $DOTFILES_REPO_PATH | tar -x -C ~

### VIM ###
install gvim

# Vundle
echo_colour "[+] Installing Vundle" "g"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo_colour "[+] ...and plugins" "g"
vim -E -c PluginInstall -c qall

### TMUX ###
install tmux

### ZSH ###
install zsh

echo_colour "[+] Installing Oh My Zsh" "g"
export KEEP_ZSHRC='yes'
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo_colour "[+] Installing Vi Mode" "y"
git clone https://github.com/jeffreytse/zsh-vi-mode ~/.oh-my-zsh/plugins/zsh-vi-mode

echo_colour "[+] Installing syntax highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
