#!/bin/bash
# ^^ Run from bash assuming we don't already have zsh running
WARN="This file is opinionated for my directory structure.\nDon't expect this to work for you out of the box!\n"

printf "${WARN}"

# this doesn't work when automated
#printf "Continue? (y/n): "
#read CONT
CONT=y

# run this command as is and .zprezto will be cloned to your home directory
# run with ZDOTDIR=/path/you/want dotfiles-install.sh
# to clone prezto to a different folder

DOTDIR="${DOTFILESDIR:-${HOME}/.dotfiles}"
ZDIR="${ZDOTDIR:-${HOME}/.dotfiles/src/.zprezto}"

if [[ $CONT == "y" ]]; then
  # first we need to put the zshenv in place to not clutter ~/ too much
  if [ -d ${ZDIR} ]
  then
      echo "linking zshenv"
      ln -s ${ZDIR}/runcoms/zshenv "${HOME}"/.zshenv
  else
      git clone --recurse https://github.com/rothgar/prezto.git "${ZDIR}"
  fi
  
  if [ -d "${DOTDIR}" ]; then
    for DOT_FILE in $( ls -A "${DOTDIR}"/ln )
      do
          ln -s "${DOTDIR}"/ln/"${DOT_FILE}" "${HOME}"/"${DOT_FILE}" 
      done
  fi
  # update and install vim plugins
  vim +PluginInstall +qall
else
  # user didn't want to continue
  exit
fi
