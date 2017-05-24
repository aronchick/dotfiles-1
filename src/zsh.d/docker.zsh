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
    s docker "$@"
  fi
}

alias dk='docker'

drmi() { d rmi $(d images -q -f dangling=true); }

alias dkl='dk logs -f'
alias dm='docker-machine'
alias dc='docker-compose'

# Get container process
alias dps="dk ps"

# Get process included stop container
alias dpsa="dk ps -a"

# Get images
alias di="dk images"

# Get container IP
alias dip="dk inspect --format '{{ .NetworkSettings.IPAddress }}'"

# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="dk run -d -P"

# Run interactive container, e.g., $dki base /bin/bash
alias dki="dk run -i -t -P --rm"
# run new container with bash
dkib() { dk run -i -t -P --rm ${1} /bin/bash }
# run bash in an existing container
dksh() { dk exec -i -t ${1} /bin/bash }

# Stop all containers
dkstop() { dk stop $(dk ps -a -q); }

# Remove all containers
dkrm() { dk rm $(dk ps -a -q -f status=exited); }

# Stop and Remove all containers
alias dkrmf='dk stop $(dk ps -a -q) && dk rm $(dk ps -a -q)'

# Remove untagged images
dkrni() { dk rmi $(di | grep "$<none>" | awk '{print $3}') }

# Remove all images
dkrai() { dk rmi $(di -q) }

# dkfile build, e.g., $dbu tcnksm/test 
dkbu() { dk build -t=$1 .; }

# Show all alias related dk
dalias() { alias | grep 'dk' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }
