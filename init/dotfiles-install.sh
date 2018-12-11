#!/bin/bash
# ^^ Run from bash assuming we don't already have zsh running
WARN="This file is opinionated for my directory structure.\nDon't expect this to work for you out of the box!\n"

printf "${WARN}"

# this doesn't work when automated
#printf "Continue? (y/n): "
#read CONT
CONT=y

DOTDIR="${DOTFILESDIR:-${HOME}/.dotfiles}"

if [[ $CONT == "y" ]]; then
  # first we need to put the zshenv in place to not clutter ~/ too much
  echo "linking zshenv"
  ln -s ${DOTDIR}/zdotdir/zshenv "${HOME}"/.zshenv

  if [ -d "${DOTDIR}" ]; then
    for DOT_FILE in $( ls -A "${DOTDIR}"/ln )
      do
        echo "creating symlink for ${DOT_FILE}"
        ln -s "${DOTDIR}"/ln/"${DOT_FILE}" "${HOME}"/"${DOT_FILE}"
      done
  fi
  # update and install vim plugins
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
else
  # user didn't want to continue
  exit
fi
