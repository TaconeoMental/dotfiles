export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"

COMPLETION_WAITING_DOTS="güan second..."

ZVM_VI_ESCAPE_BINDKEY=jj

plugins=(git zsh-vi-mode)

export VISUAL=vim
export EDITOR="$VISUAL"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

alias amimir='sudo pacman -Syu; shutdown 0'
alias fuck='sudo $(fc -ln -1)'

source $ZSH/oh-my-zsh.sh
