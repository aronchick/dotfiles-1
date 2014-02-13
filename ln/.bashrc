# ~/.bashrc: executed by bash(1) for non-login shells.

#============Source External files==================
# Source all files in ~/.dotfiles/src/
function src() {
  local file
  if [[ "$1" ]]; then
    source "$HOME/.dotfiles/src/$1.sh"
  else
    for file in ~/.dotfiles/src/*; do
      source "$file"
    done
  fi
}

src