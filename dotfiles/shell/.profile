case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$HOME/bin:$PATH" ;;
esac
export PATH
export EDITOR=nvim
export VISUAL=nvim
