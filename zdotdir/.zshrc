#-----------VARS----------------------

export SHELL='/bin/zsh'
export CDPATH='.:~:~/src/'
export GOROOT=$HOME/bin/go
export GOPATH=$HOME/go
export RSYNC_RSH=ssh
export JAVA_HOME='/usr/java/latest'
export HISTSIZE='10000'
export SAVEHIST='100000'
export HISTFILE=$HOME/.dotfiles/src/.zhistory
export WORKON_HOME=$HOME/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export TZ=':/etc/localtime'
export PATH=$HOME/bin:$GOPATH/bin:$GOROOT/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export LESS='-F -g -i -M -R -S -w -X -z-4'   # default less options

#------------OPTIONS------------------

setopt DVORAK                    # use dvorak keyboard layout for misspelled suggestions
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands
setopt extended_glob             # more glob features
setopt RC_QUOTES                 # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
# Job management
setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Dont run all background jobs at a lower priority.
unsetopt HUP              # Dont kill jobs on shell exit.
unsetopt CHECK_JOBS       # Dont report on jobs when shell exit.
# Directory stuff
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

#------------ALIASES------------------

# Directory listing

alias ll='ls -AlFh'
alias la='ls -A'
alias l='ls -CF'
alias latr='ls -lAtr'
alias lla='ll -A'
alias l1='ls -1A'       # All files in 1 column
alias tree='tree -F'
alias tre='tree -F -L 1'

# Easier navigation: .., ..., -
alias ..='cd ..'
alias ....='cd ../..'
alias xxx='exit'
alias :q='exit'
alias -- --='cd -'
alias dl="cd ~/downloads"
alias src="cd ~/src"
alias pp="cd ~/pp"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -A -s 10240 'tcp port 4080 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)' \
    | egrep --line-buffered \"^........(GET |HTTP\/|POST |HEAD )|^[A-Za-z0-9-]+: \" \
    | sed -r 's/^........(GET |HTTP\/|POST |HEAD )/\n\1/g'"

# hosts
alias hosts='sudo vim /etc/hosts'

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"
alias du='du -ch'

if (( $+commands[subscription-manager] )) ; then
    alias sm="sudo subscription-manager"
fi

# MISC commands
alias g='git'
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias lsg="sudo lsof | grep"

# Use NeoVim if it's installed
if (( $+commands[nvim] )); then
    alias vim='nvim'
    export EDITOR='nvim'
    export VISUAL='nvim'
fi
alias v='vim'
alias sv='sudo vim'

alias lmsg='sudo less +F /var/log/messages'
alias dmsg='less +F /var/log/dmesg'
alias -g H='| head'
alias -g L='| less'
alias -g G='| grep'
alias -g W='| wc -l'
alias -g C="| tr -d '\n' | xclip -selection clipboard"

alias df="df -h"
alias rpg="rpm -qa | grep -i"
alias ylist='yum list --showduplicates'
alias ygroups="yum groupinfo '*' | less +/"
alias curl-trace='curl -w "@${HOME}/.dotfiles/ln/curl-format" -o /dev/null -s'
alias open='xdg-open'
# Let me use aliases with watch command
alias watch="watch "

# *ctl
alias sc='sudo systemctl'
alias scs='systemctl status'
alias scr='sudo systemctl restart'
alias scc='systemctl cat'
alias jc='sudo journalctl'
alias jcf='sudo journalctl -flu'
alias mc='sudo machinectl'

function AP() {
    if [[ -z $1 ]]; then
        awk '{print $1}'
    else
        if [[ -z $2 ]]; then
            awk "{print $"${1}" }"
        else
            awk -F $2 "{print $"${1}" }"
        fi
    fi
}
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Show top 10 commands
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# Key binds
# Use Ctrl+r even if I'm using vi key bindings
bindkey '^R' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
# ^S and ^Q cause problems and I don't use them. Disable stty stop.
stty stop ""
stty start ""
bindkey -M vicmd k vi-up-line-or-history
bindkey -M vicmd j vi-down-line-or-history

#------------FUNCTIONS----------------

# attach to a tmux session or start a new session if one doesn't exist
function muxt() { tmux attach || tmux }
# bind above function to Ctrl+t
# ^q = pushline, \n = execute by entering a new line
bindkey -s '^[t' '^qmuxt\n'

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

function oscat() {
    if [ -e /etc/redhat-release ]; then
        cat /etc/redhat-release
    else
        cat /etc/os-release
    fi
}
# Search history with h $arg or just type h for full history
function h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

function vncc() { vncviewer "${1}":1 & }

function shr() { ssh root@"${1}" }
function shnr() { sshno root@"${1}" }

# print yum environment variables
function printyumenv() { python -c 'import yum, pprint; yb = yum.YumBase(); pprint.pprint(yb.conf.yumvar, width=1)'}

# start a vnc server on :99 using display :0
function start-vnc0() { x11vnc -display :0 -rfbport 5999 -repeat -noncache -q -bg & }

function extract-rpm() { rpm2cpio "$1" | cpio -idmv; }

function show-cert() { sudo openssl x509 -text -in "$1"; }

# remove host key for ssh
function rm-sshkey() {
  MATCH=$(sed -n "/$1/p" $HOME/.ssh/known_hosts)
  if [[ ! -z $MATCH ]]; then
    echo -e "\e[1;32m Matched Lines \e[0m"
    echo $MATCH
  else
    echo "No key found"
    return
  fi
  local CONFIRM=N
  echo "Delete? (y/N): "
  read CONFIRM
  if [[ $CONFIRM == 'y' ]]; then
    sed -i "/$1/d" $HOME/.ssh/known_hosts
  else
    printf "replace aborted"
  fi
}

# Enable completions
zmodload -i zsh/parameter
if ! (( $+functions[compdef] )) ; then
  autoload -U +X compinit && compinit
  autoload -U +X bashcompinit && bashcompinit
fi

# Most important functions
disappointed() { echo -n " ಠ_ಠ " |tee /dev/tty| xclip -selection clipboard; }
flip() { echo -n "（╯°□°）╯ ┻━┻" |tee /dev/tty| xclip -selection clipboard; }
shrug() { echo -n "¯\_(ツ)_/¯" |tee /dev/tty| xclip -selection clipboard; }
matrix() { echo -e "\e[1;40m" ; clear ; while :; do echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(( $RANDOM % 72 )) ;sleep 0.05; done|awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}' }

# Backup funciton
bu() { cp "$1" "$1".backup-`date +%y%m%d`; }

settitle() {
    printf "\033k$1\033\\"
}

hexip() {
  # if given a dotted ip, convert to hex
  if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    printf '%02X' $(echo ${1//./ }) ; echo
  # if given hex, convert to dotted ip
  elif [[ $1 =~ ^([0-9A-Fa-f]{2})*$ ]]; then
    printf "%d." $(echo $1 | sed 's/../0x& /g' | tr ' ' '\n' ) | sed 's/\.$/\n/'
  # if given hostname, output dotted ip and hex ip
  else
    gethostip -dx $1
  fi
}

# git diff with fzf
function fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always %'" \
             --bind "enter:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# interactive man search
function  mans(){
man -k . | fzf -n1,2 --preview "echo {} | cut -d' ' -f1 | sed 's# (#.#' | sed 's#)##' | xargs -I% man %" --bind "enter:execute: (echo {} | cut -d' ' -f1 | sed 's# (#.#' | sed 's#)##' | xargs -I% man % | less -R)"
}

# Copy an ip address from a domain
# Usage cip domain.com
function cip() {
	ip=$(host $1 | grep "has address" \
       | awk '{match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/); ip = substr($0,RSTART,RLENGTH); print ip}')
	printf $ip | xclip -selection clipboard
	echo $ip
}

if [[ -f "/usr/local/bin/virtualenvwrapper.sh" ]]; then
  source "/usr/local/bin/virtualenvwrapper.sh"
fi

return-limits(){
     for process in $@; do
          process_pids=`ps -C $process -o pid --no-headers | cut -d " " -f 2`

          if [ -z $@ ]; then
             echo "[no $process running]"
          else
             for pid in $process_pids; do
                   echo "[$process #$pid -- limits]"
                   cat /proc/$pid/limits
             done
          fi
     done
 }

# special sourcing for syntax highlighting
if [[ -d ${ZDOTDIR:-$HOME}/zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting ]]; then
    source ${ZDOTDIR:-$HOME}/zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting
fi

# Load external files
if [[ -d "${ZDOTDIR:-$HOME}"/zsh.d ]]; then
    for ZSH_FILE in $(ls -A "${ZDOTDIR:-$HOME}"/zsh.d/*.zsh); do
        source "${ZSH_FILE}"
    done
fi

# The next line updates PATH for the Google Cloud SDK.
if [[ -d $HOME/bin/google-cloud-sdk ]]; then
  source '/home/jgarr/bin/google-cloud-sdk/path.zsh.inc'
fi

# gcloud command completion
if [[ -d $HOME/src/gcloud-zsh-completion ]]; then
  fpath=($HOME/src/gcloud-zsh-completion/src/ $fpath)
  autoload -U compinit compdef
  compinit
fi

# enable docker command stacking
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

