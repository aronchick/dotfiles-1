# https://github.com/tcnksm/docker-alias
# ------------------------------------
# Docker alias and function
# ------------------------------------
# docker functions
function dk() {
  if [ ! -z "${DOCKER_HOST}"]; then
    # don't need sudo if using a remote host
    docker "$@"
  else
    s docker "$@"
  fi
}

drmi() { d rmi $(d images -q -f dangling=true); }

alias dl='dk logs -f'
alias dm='docker-machine'
alias dc='docker-compose'

# docker swarm alias >1.12
alias ds='dk swarm'

# Get latest container ID
alias dl="dk ps -l -q"

# Get container process
alias dps="dk ps"

# Get process included stop container
alias dpa="dk ps -a"

# Get images
alias di="dk images"

# Get container IP
alias dip="dk inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="dk run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="dk run -i -t -P"

# Execute interactive container, e.g., $dex base /bin/bash
alias dex="dk exec -i -t"

# Stop all containers
dstop() { dk stop $(dk ps -a -q); }

# Remove all containers
drm() { dk rm $(dk ps -a -q -f status=exited); }

# Stop and Remove all containers
alias drmf='dk stop $(dk ps -a -q) && dk rm $(dk ps -a -q)'

# Remove all images
dri() { dk rmi $(dk images -q); }

# dkfile build, e.g., $dbu tcnksm/test 
dbu() { dk build -t=$1 .; }

# Show all alias related dk
dalias() { alias | grep 'dk' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Bash into running container
dbash() { dk exec -it $(dk ps -aqf "name=$1") bash }
