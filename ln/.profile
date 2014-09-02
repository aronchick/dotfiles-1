# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.dotfiles/bin" ] ; then
    PATH=$HOME/.dotfiles/bin:$PATH
    export PATH
fi

# set PATH so it includes ~/opt if it exists
if [ -d "$HOME/opt" ] ; then
    PATH=$HOME/opt:$PATH
    export PATH
fi
