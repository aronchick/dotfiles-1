#!/bin/zsh
#Use Ctrl-x,Ctrl-l to get the output of the last command
zmodload -i zsh/parameter
insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
bindkey "^Q^L" insert-last-command-output

