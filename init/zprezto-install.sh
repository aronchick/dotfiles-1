#!/bin/zsh
export ZDOTDIR=$HOME/.dotfiles/src

setopt EXTENDED_GLOB
for RCFILE in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md; do
  ln -s "${RCFILE}" "${ZDOTDIR:-$HOME}"/."${RCFILE:t}"
done

# move the symlink we just made to ~/ because that's the only place it works
mv "${ZDOTDIR:-$HOME}"/.zshenv ~/.zshenv
