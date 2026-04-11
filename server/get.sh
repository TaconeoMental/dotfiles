#!/usr/bin/env bash
set -Eeuo pipefail

#REPO_URL="https://github.com/TaconeoMental/dotfiles.git"
REPO_URL="git://192.168.1.93/dotfiles"
REPO_BRANCH="master"
REPO_DIR="${HOME}/.local/share/dotfiles"

log() {
  printf '\033[1;35m[get]\033[0m %s\n' "$*"
}

fail() {
  printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2
  exit 1
}

ensure_not_root() {
  if [ "$(id -u)" -eq 0 ]; then
    fail "Don't run this script as root"
  fi
}

require_os_release() {
  [ -r /etc/os-release ] || fail "Could not detect distro"
}

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    return 0
  fi

  log "Git is not installed"

  . /etc/os-release

  case "${ID:-}" in
    debian|ubuntu)
      sudo apt-get update
      sudo apt-get install -y git ca-certificates
      ;;
    *)
      case " ${ID_LIKE:-} " in
        *" debian "*)
          sudo apt-get update
          sudo apt-get install -y git ca-certificates
          ;;
        *)
          fail "Can't install Git for this distro"
          ;;
      esac
      ;;
  esac
}

clone_or_update_repo() {
  mkdir -p "$(dirname "$REPO_DIR")"

  if [ ! -d "$REPO_DIR/.git" ]; then
    log "Cloning dotfiles repository..."
    git clone --depth=1 --branch "$REPO_BRANCH" "$REPO_URL" "$REPO_DIR"
  else
    log "Updating dotfiles repository..."
    git -C "$REPO_DIR" fetch --depth=1 origin "$REPO_BRANCH"
    git -C "$REPO_DIR" checkout "$REPO_BRANCH"
    git -C "$REPO_DIR" reset --hard "origin/$REPO_BRANCH"
  fi
}

exec_platform_bootstrap() {
  local target=""

  . /etc/os-release

  case "${ID:-}" in
    debian|ubuntu)
      target="$REPO_DIR/bootstrap/debian.sh"
      ;;
    *)
      case " ${ID_LIKE:-} " in
        *" debian "*) target="$REPO_DIR/bootstrap/debian.sh" ;;
      esac
      ;;
  esac

  [ -n "$target" ] || fail "Distro not supported. ID=${ID:-unknown}"
  [ -f "$target" ] || fail "Could not find distro target script: $target"

  exec bash "$target"
}

main() {
  ensure_not_root
  require_os_release
  ensure_git
  clone_or_update_repo
  exec_platform_bootstrap
}

main "$@"
