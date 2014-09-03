# Warning, this file is opinionated for my directory structure.
# Don't expect this to work for you out of the box!

# run this command as is and .zprezto will be cloned to your home directory
# run with ZDOTDIR=/path/you/want dotfiles-install.sh
# to clone prezto to a different folder

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

