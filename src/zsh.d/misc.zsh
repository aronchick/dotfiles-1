alias sshno='ssh -o "StrictHostKeyChecking=no" -o "GlobalKnownHostsFile=/dev/null" -o "UserKnownHostsFile=/dev/null"'
alias sshpw="ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no"

# login to a server as root without host key checking
shrno() {
  ssh -o "StrictHostKeyChecking=no" -o "GlobalKnownHostsFile=/dev/null" -o "UserKnownHostsFile=/dev/null" root@${1}
}
