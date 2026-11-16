export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"

ZVM_VI_ESCAPE_BINDKEY=jj

plugins=(git zsh-vi-mode fast-syntax-highlighting)

# Own completions (e.g. `t`). Before oh-my-zsh, which runs compinit
fpath=(~/.zsh/completions $fpath)

source $ZSH/oh-my-zsh.sh

zvm_after_init() {
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey -M vicmd 'vv' edit-command-line
}

if command -v apt-get >/dev/null 2>&1; then
  alias amimir='sudo apt-get update && sudo apt-get dist-upgrade -y; shutdown 0'
fi
alias fuck='sudo $(fc -ln -1)'
alias tmux="TERM=xterm-256color tmux"

# Refresh environment variables if inside tmux
# From https://github.com/ibab/dotfiles/raw/master/zshrc :)
if [ -n "$TMUX" ]; then
    function update_tmux_env {
        sshauth=$(tmux show-environment | grep "^SSH_AUTH_SOCK")
        if [[ -n "$sshauth" ]]; then
            export "$sshauth"
        fi
        display=$(tmux show-environment | grep "^DISPLAY")
        if [[ -n "$display" ]]; then
            export "$display"
        fi
    }
else
    function update_tmux_env { }
fi

add-zsh-hook precmd update_tmux_env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
