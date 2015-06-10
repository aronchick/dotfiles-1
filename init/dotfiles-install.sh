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

if [[ $CONT == "y" ]]; then
  # first we need to put the zshenv in place to not clutter ~/ too much
  if [ -d "${HOME}"/.dotfiles/src/.zprezto ]
  then
      echo "linking zshenv"
      ln -s "${HOME}"/.dotfiles/src/.zprezto/runcoms/zshenv "${HOME}"/.zshenv
  else
      git clone --recurse https://github.com/rothgar/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  fi
  
  source "${HOME}"/.zshenv
  
  if [ -d "${HOME}"/.dotfiles ]; then
      for DOT_FILE in $( ls -A "${HOME}"/.dotfiles/ln/ )
      do
          echo "linking ${DOT_FILE}"
          ln -s "${HOME}"/.dotfiles/ln/"${DOT_FILE}" "${HOME}"/"${DOT_FILE}" 
      done
  fi
  # update and install vim plugins
  vim +PluginInstall +qall
else
  # user didn't want to continue
  exit
fi
