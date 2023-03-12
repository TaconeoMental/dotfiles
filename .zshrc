# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="güan second..."

plugins=(git zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

export VISUAL=vim
export EDITOR="$VISUAL"

# alias ohmyzsh="mate ~/.oh-my-zsh"
alias amimir='sudo pacman -Syu; shutdown 0'
alias fuck='sudo $(fc -ln -1)'

#autoload edit-command-line
#zle -N edit-command-line
#bindkey -M vicmd v edit-command-line
