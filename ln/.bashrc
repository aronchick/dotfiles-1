#================Manage history===================  
# enable immediately flushing and loading bash history  
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"  
  
# don't put duplicate lines or lines starting with space in the history.  
# See bash(1) for more options  
HISTCONTROL=ignoreboth:erasedups  

# Save multi-line commands as one command
shopt -s cmdhist

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
  
# append to the history file, don't overwrite it  
shopt -s histappend  

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"
  
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)  
HISTSIZE=100000  
HISTFILESIZE=20000000  
# Useful timestamp format
HISTTIMEFORMAT='%F %T '
  
#================EDITOR===================  
export EDITOR=vim  
export VISUAL=vim  
alias vi='vim'  
  
#===============MISC ALIASES===================  
#alias ll='ls -alFh'  
alias la='ls -A'  
alias l='ls -CF'  
alias latr='ls -lAtr'  
  
# Easier navigation: .., ..., -  
alias ..='cd ..'  
alias ...='cd ../..'  
alias -- -='cd -'  
# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null
  
# File size  
alias fs="stat -f '%z bytes'"  
alias df="df -h"  
alias du='du -ch'  
  
# Create a new directory and enter it  
function md() {  
  mkdir -p "$@" && cd "$@"  
}  
  
# enable programmable completion features (you don't need to enable  
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile  
# sources /etc/bash.bashrc).  
if ! shopt -oq posix; then  
  if [ -f /usr/share/bash-completion/bash_completion ]; then  
    . /usr/share/bash-completion/bash_completion  
  elif [ -f /etc/bash_completion ]; then  
    . /etc/bash_completion  
  fi  
fi  
  
# SSH auto-completion based on entries in known_hosts.  
if [[ -e ~/.ssh/known_hosts ]]; then  
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp  
fi  
  
# Case-insensitive globbing (used in pathname expansion)  
shopt -s nocaseglob  
  
#==============Prompt Options============================  
# set a fancy prompt (non-color, unless we know we "want" color)  
case "$TERM" in  
  xterm-color) color_prompt=;;  
esac  
  
force_color_prompt=yes  
  
if [ -n "$force_color_prompt" ]; then  
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then  
color_prompt=yes  
  else  
color_prompt=  
  fi  
fi  
  
# You need to source the git-prompt.sh file for a git prompt  
# The original file can be found here  
# git/git-prompt.sh at master · git/git · GitHub  
# put it in ~/.git-prompt.sh  
if [ -f "${HOME}"/.git-prompt.sh ]; then  
  source "${HOME}"/.git-prompt.sh  
fi  

# helper function for git prompt  
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

# There are a million prompt themes out there. This is one I liked and modified  
if [ "$color_prompt" = yes ] && [ -n "$SSH_CLIENT" ]; then  
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[0;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[1;33m\]$(__git_ps1 " (%s$(parse_git_dirty))")\[\033[00m\]\$ '  
elif [ "$color_prompt" = yes ]; then  
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[1;33m\]$(__git_ps1 " (%s$(parse_git_dirty))")\[\033[00m\]\$ '  
else  
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\[\033[1;33m\]$(__git_ps1 " (%s$(parse_git_dirty))")\[\033[00m\]\$ '  
fi  
  
unset color_prompt force_color_prompt  
  
# If this is an xterm set the title to user@host:dir  
case "$TERM" in  
xterm*|rxvt*)  
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"  
  ;;  
*)  
  ;;  
esac

