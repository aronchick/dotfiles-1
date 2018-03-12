# https://github.com/tcnksm/docker-alias
# ------------------------------------
# Docker alias and function
# ------------------------------------
# docker functions
function docker() {
  if [ ! -z "${DOCKER_HOST}"]; then
    # don't need sudo if using a remote host
    docker "$@"
  else
    sudo docker "$@"
  fi
}

alias docker='docker'

drmi() { docker rmi $(docker images -q -f dangling=true); }

alias dkl='docker logs -f'
alias dm='docker-machine'
alias dc='docker-compose'

# Get container process
alias dps="docker ps"

# Get process included stop container
alias dpsa="docker ps -a"

# Get images
alias di="docker images"

# Get container IP
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="docker run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t --rm"

# run new container with bash
dkib() { docker run -i -t -P --rm ${1} /bin/bash }

# run bash in an existing container
dksh() { docker exec -i -t ${1} /bin/bash }

# Stop all containers
dkstop() { docker stop $(docker ps -a -q); }

# Remove all containers
dkrm() { docker rm $(docker ps -a -q -f status=exited); }

# Stop and Remove all containers
alias dkrmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Remove untagged images
dkrni() { docker rmi $(docker images | grep "$<none>" | awk '{print $3}') }

# Remove all images
dkrai() { docker rmi $(docker images -q) }

# dkfile build, e.g., $dbu tcnksm/test 
dkbu() { docker build -t=$1 .; }

# dockly
alias dockly='docker run -it --rm --name dockly -v /var/run/docker.sock:/var/run/docker.sock rothgar/dockly:latest'

# amtctl
alias amtctrl='docker run -it --rm --name amtctrl -v ~/.config/amtctrl/hosts.cfg:/root/.config/amtctrl/hosts.cfg rothgar/amtctrl'
