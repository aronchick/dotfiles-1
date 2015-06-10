#!/bin/bash
export ZDOTDIR=$HOME/.dotfiles/src

shopt -s extglob
for RCFILE in $( ls -A "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/ ); do
  ln -s "${ZDOTDIR}"/.zprezto/runcoms/"${RCFILE}" "${ZDOTDIR:-$HOME}"/."${RCFILE:t}"
done

# move the symlink we just made to ~/ because that's the only place it works
mv "${ZDOTDIR:-$HOME}"/.zshenv ~/.zshenv
