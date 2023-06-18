export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"

ZVM_VI_ESCAPE_BINDKEY=jj

plugins=(git zsh-vi-mode fast-syntax-highlighting)


export VISUAL=vim
export EDITOR="$VISUAL"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

alias amimir='sudo pacman -Syu --noconfirm; paccache -r; shutdown 0'
alias fuck='sudo $(fc -ln -1)'
alias tmux="TERM=xterm-256color tmux"

source $ZSH/oh-my-zsh.sh
