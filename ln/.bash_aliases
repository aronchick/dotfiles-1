# ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Package management
alias update="sudo apt-get -qq update && sudo apt-get upgrade"
alias install="sudo apt-get install"
alias remove="sudo apt-get remove"
alias search="apt-cache search"

# RDP shortcuts
alias rdp='xfreerdp -u jlg -d apu --rfx -x 80 -g 1680x1050 --disable-full-window-drag'
alias rdpf='xfreerdp -u jlg -d apu --rfx -x 80 -f --disable-full-window-drag'

# MISC commands
alias gam="python ~/opt/gam/gam.py"
