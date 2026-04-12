#!/usr/bin/env bash
set -Eeuo pipefail

OS_FAMILY="debian"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

install_packages() {
  log "Installing Debian packages..."
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl rsync ca-certificates sudo \
    zsh tmux neovim keychain \
    python3 python3-venv python3-pip \
    xorg xinit xbacklight dbus-x11 \
    i3 i3lock i3blocks rofi dunst dex picom feh \
    alacritty flameshot ranger \
    scrot imagemagick playerctl libnotify-bin \
    brightnessctl lxpolkit \
    network-manager-gnome \
    fonts-noto-core fonts-font-awesome \
    alsa-utils pavucontrol power-profiles-daemon \
    ripgrep firefox-esr lightdm lightdm-gtk-greeter
}

install_i3lock_color() {
  if i3lock --help 2>&1 | grep -q 'ring-color'; then
    return 0
  fi

  log "Installing i3lock-color from source..."
  sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev \
    libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev \
    libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev \
    libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev \
    libjpeg-dev libgif-dev

  local tmp
  tmp=$(mktemp -d)
  git clone --depth=1 https://github.com/Raymo111/i3lock-color.git "$tmp/i3lock-color"
  (cd "$tmp/i3lock-color" && bash install-i3lock-color.sh)
  rm -rf "$tmp"
}

main() {
  require_not_root
  require_sudo
  install_packages
  install_i3lock_color
  sync_dotfiles
  install_oh_my_zsh
  install_zsh_plugins
  install_tpm
  ensure_nvim_python_host
  install_tmux_plugins
  install_nvim_plugins
  install_gtk_theme
  set_zsh_default
  final_message
}

main "$@"
