# dotfiles

## Installation

`$ curl -fsSL https://get.kippel.org | bash`

This clones the repo to `~/.local/share/dotfiles`, installs packages and links everything into `$HOME`.

## Layout

Every directory inside `dotfiles/` is a [GNU Stow](https://www.gnu.org/software/stow/) package that mirrors `$HOME`:

```
dotfiles/
|-- tmux/   .tmux.conf
|-- nvim/   .config/nvim/...
|-- zsh/    .zshrc
'-- ...
```

## Linking only

```
$ bootstrap/link.sh              # every package
$ bootstrap/link.sh tmux nvim    # only some (e.g. on a server without DE)
```

Real files that are in the way are moved to `~/.dotfiles-backup/<date>/`.

To add a new config file, move it into a package and run `bootstrap/link.sh` again.
