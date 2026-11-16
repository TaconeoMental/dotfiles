#!/usr/bin/env bash
set -Eeuo pipefail

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$BOOTSTRAP_DIR/.." && pwd)"
HOME_DIR="${HOME}"
OS_FAMILY="${OS_FAMILY:-unknown}"
DOTFILES_ROOT=""

log() {
  printf '\033[1;36m[bootstrap]\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2
}

fail() {
  printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_not_root() {
  if [ "$(id -u)" -eq 0 ]; then
    fail "Don't run this script as root"
  fi
}

require_sudo() {
  if ! command_exists sudo; then
    fail "Sudo not installed"
  fi
  sudo -v
}

resolve_dotfiles_root() {
  DOTFILES_ROOT="$REPO_ROOT/dotfiles"
  [ -d "$DOTFILES_ROOT" ] || fail "Could not find dotfiles directory: $DOTFILES_ROOT"
}

list_packages() {
  find "$DOTFILES_ROOT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
}

# Moves real files that block stow to ~/.dotfiles-backup/<date>/.
backup_conflicts() {
  local pkg="$1"
  local backup_dir="$2"
  local rel target src

  while IFS= read -r rel; do
    rel="${rel#./}"
    target="$HOME_DIR/$rel"
    src="$DOTFILES_ROOT/$pkg/$rel"

    if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$src")" ]; then
      continue
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      mkdir -p "$backup_dir/$(dirname "$rel")"
      mv "$target" "$backup_dir/$rel"
      warn "Backed up ~/$rel -> $backup_dir/$rel"
    fi
  done < <(cd "$DOTFILES_ROOT/$pkg" && find . \( -type f -o -type l \))
}

# link_dotfiles <package...>
# If called without arguments it links all packages
link_dotfiles() {
  resolve_dotfiles_root
  command_exists stow || fail "stow is not installed"

  local -a packages=("$@")
  if [ "${#packages[@]}" -eq 0 ]; then
    mapfile -t packages < <(list_packages)
  fi

  local backup_dir
  backup_dir="$HOME_DIR/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

  local pkg
  for pkg in "${packages[@]}"; do
    [ -d "$DOTFILES_ROOT/$pkg" ] || fail "Unknown package: $pkg"
    backup_conflicts "$pkg" "$backup_dir"
  done

  log "Linking packages: ${packages[*]}"
  stow -d "$DOTFILES_ROOT" -t "$HOME_DIR" --no-folding --restow "${packages[@]}"
}

sync_dotfiles() {
  link_dotfiles

  if command_exists xrdb && [ -n "${DISPLAY:-}" ]; then
    xrdb -merge "$HOME_DIR/.Xresources" 2>/dev/null || true
  fi

  if [ -d "$REPO_ROOT/etc/lightdm" ]; then
    sudo rsync -a "$REPO_ROOT/etc/lightdm/" "/etc/lightdm/"
  fi
}

install_oh_my_zsh() {
  if [ -d "$HOME_DIR/.oh-my-zsh" ]; then
    return 0
  fi

  log "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

clone_or_ff_pull() {
  local repo_url="$1"
  local dst="$2"

  if [ ! -d "$dst/.git" ]; then
    mkdir -p "$(dirname "$dst")"
    git clone --depth=1 "$repo_url" "$dst"
  else
    git -C "$dst" fetch --depth=1 origin
    git -C "$dst" reset --hard origin/HEAD
  fi
}

install_zsh_plugins() {
  local custom_plugins="$HOME_DIR/.oh-my-zsh/custom/plugins"
  mkdir -p "$custom_plugins"

  log "Installing ZSH plugins..."
  clone_or_ff_pull "https://github.com/jeffreytse/zsh-vi-mode" "$custom_plugins/zsh-vi-mode"
  clone_or_ff_pull "https://github.com/zdharma-continuum/fast-syntax-highlighting" "$custom_plugins/fast-syntax-highlighting"
}

install_tpm() {
  log "Installing TPM..."
  clone_or_ff_pull "https://github.com/tmux-plugins/tpm" "$HOME_DIR/.tmux/plugins/tpm"
}

ensure_nvim_python_host() {
  local venv_dir="$HOME_DIR/.venvs/nvim"
  local py="$venv_dir/bin/python"

  if ! command_exists python3; then
    warn "python3 not found. Ignoring python host for Neovim"
    return 0
  fi

  if [ ! -x "$py" ]; then
    log "Creating virtualenv for Neovim: $venv_dir"
    python3 -m venv "$venv_dir"
  fi

  "$py" -m pip install --upgrade pip pynvim >/dev/null
}

install_nvim_plugins() {
  if ! command_exists nvim; then
    return 0
  fi

  log "Syncing Neovim plugins..."
  nvim --headless '+Lazy! sync' +qa >/tmp/bootstrap-nvim.log 2>&1 || warn "Check /tmp/bootstrap-nvim.log"
}

install_tmux_plugins() {
  local installer="$HOME_DIR/.tmux/plugins/tpm/bin/install_plugins"

  if [ -x "$installer" ]; then
    log "Installing tmux plugins..."
    "$installer" >/dev/null 2>&1 || true
  fi
}

set_zsh_default() {
  local zsh_path

  zsh_path="$(command -v zsh || true)"
  [ -n "$zsh_path" ] || return 0

  if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
    if grep -qxF "$zsh_path" /etc/shells; then
      log "Changing default shell..."
      sudo chsh -s "$zsh_path" "$USER"
    else
      warn "$zsh_path not in /etc/shells."
    fi
  fi
}

install_gtk_theme() {
  log "Generating GTK theme..."

  local theme_src="$REPO_ROOT/theme/pinky.theme"
  local theme_dst="$HOME_DIR/.themes/pinky_theme"
  local theme_sys="/usr/share/themes/pinky_theme"
  local oomox_dir
  oomox_dir=$(mktemp -d)

  [ -f "$theme_src" ] || return 0

  sudo apt install -y \
    libgdk-pixbuf-xlib-2.0-dev libxml2-utils \
    gtk2-engines-murrine librsvg2-bin sassc bc

  git clone --depth=1 \
    "https://github.com/themix-project/oomox-gtk-theme.git" \
    "$oomox_dir"

  rm -rf "$theme_dst"
  "$oomox_dir/change_color.sh" -o pinky_theme "$theme_src"

  rm -rf "$oomox_dir"
  sudo rm -rf "$theme_sys"
  sudo cp -r "$theme_dst" "$theme_sys"
}

install_icon_theme() {
  log "Customizing Papirus icons..."

  local folders_script
  folders_script=$(mktemp)

  curl -fsSL \
    "https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders" \
    -o "$folders_script"
  chmod +x "$folders_script"

  sudo "$folders_script" -C pink --theme Papirus-Dark

  rm -f "$folders_script"
}

final_message() {
  log "All set :)"
}
