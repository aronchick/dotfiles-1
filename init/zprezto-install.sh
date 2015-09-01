#!/bin/bash

RUN_USER=${SUDO_USER:-${USER}}
ZDIR=${ZDOTDIR:-/home/${RUN_USER}/.dotfiles/src}

shopt -s extglob
for RCFILE in $( ls -A "${ZDIR}"/.zprezto/runcoms/ ); do
  ln -s "${ZDIR}"/.zprezto/runcoms/"${RCFILE}" "${ZDIR}"/."${RCFILE:t}"
done

# move the symlink we just made to ~/ because that's the only place it works
mv "${ZDIR}"/.zshenv ~/.zshenv
