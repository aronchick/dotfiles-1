# Directory listing
if [[ "$(type -P tree)" ]]; then
  alias ll='tree --dirsfirst -aLpughDFiC 1'
  alias lsd='ll -d'
else
  alias ll='ls -alh'
  alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
fi

#alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Easier navigation: .., ..., -
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"
alias du='du -ch'

# Package management
alias update="sudo apt-get -qq update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"

# RDP shortcuts
alias rdp='xfreerdp -u jlg -d apu --rfx -x 80 -g 1600x900 --disable-full-window-drag'
alias rdpf='xfreerdp -u jlg -d apu --rfx -x 80 -f --disable-full-window-drag'

# MISC commands
alias gam="python ~/opt/gam/gam.py"
alias gtfo="/dev/null"
alias stfu="/dev/null"
alias wtf="/dev/urandom"
alias mount='mount | column -t'
alias h='history'

# setup worktunnel in .ssh/config
alias sshwt='ssh -A -t worktunnel ssh -A -t'
# setup hometunnel is .ssh/config
alias sshht='ssh -A -t hometunnel ssh -A -t'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
