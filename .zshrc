export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="alanpeabody"

ZVM_VI_ESCAPE_BINDKEY=jj

plugins=(git zsh-vi-mode fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export VISUAL=vim
export EDITOR="$VISUAL"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

alias amimir='sudo pacman -Syu --noconfirm; paccache -r; shutdown 0'
alias fuck='sudo $(fc -ln -1)'
alias tmux="TERM=xterm-256color tmux"
alias tls="tmux ls"

function trs {
    ssh $1 -t LANG=$LANG tmux ls
}

# Attaches to a tmux session or starts a new one
# Tmux local attach
function tla {
    session_name="$1"
    if [ -z "$1" ]; then
        session_name="MAIN"
    fi
    tmux attach-session -t $session_name
    if [ $? -eq 1 ]; then
        echo "Starting new session..."
        tmux new-session -s $session_name
    fi
}

# Attaches to a remote tmux session or starts a new one
# Tmux remote attach
function tra {
    session_name="MAIN"
    if [ -n "$2" ]; then
        session_name="$2"
    fi
    ssh $1 -t LANG=$LANG tmux attach-session -t $session_name
    if [ $? -eq 1 ]; then
        echo "Starting new session..."
        ssh $1 -t LANG=$LANG tmux new-session -s $session_name
    fi
}

# Refresh environment variables if inside tmux
# From https://github.com/ibab/dotfiles/raw/master/zshrc :)
if [ -n "$TMUX" ]; then
    function update_tmux_env {
        sshauth=$(tmux show-environment | grep "^SSH_AUTH_SOCK")
        if [ $sshauth ]; then
            export $sshauth
        fi
        display=$(tmux show-environment | grep "^DISPLAY")
        if [ $display ]; then
            export $display
        fi
    }
else
    function update_tmux_env { }
fi

add-zsh-hook precmd update_tmux_env

eval $(keychain --eval --quiet id_ed25519 id_rsa)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
