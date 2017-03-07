alias sshno='ssh -o "StrictHostKeyChecking=no" -o "GlobalKnownHostsFile=/dev/null" -o "UserKnownHostsFile=/dev/null"'
alias sshpw="ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no"

# login to a server as root without host key checking
shrno() {
  ssh -o "StrictHostKeyChecking=no" -o "GlobalKnownHostsFile=/dev/null" -o "UserKnownHostsFile=/dev/null" root@${1}
}

curl-cert() {
  openssl s_client -showcerts -connect "${1}":443 -servername ${1}
}

book(){
    BRANCH=`git branch | grep \* | cut -d ' ' -f2`
    git add .
    git commit -m "Another book commit"
    git push atlas ${BRANCH}
    git push origin ${BRANCH}
    O=$(atlas build --pdf -b ${BRANCH})
    LINK=$(echo "${O}" | grep pdf | awk -F "> " '{print $2}')
    xdg-open $LINK
}
