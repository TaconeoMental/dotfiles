export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
if command -v flatpak >/dev/null 2>&1; then
    export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
fi
export EDITOR=nvim
export VISUAL=nvim
