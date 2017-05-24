# wrappers for docker run commands
# Shamelessly stolen from Jess
# https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc
#
# Only load these if docker is installed on the system
if command -v "docker" &>/dev/null; then
    export DOCKER_REPO_PREFIX=jess
    
    #
    # Helper Functions
    #
    dcleanup(){
    	local containers
    	containers=( $(docker ps -aq 2>/dev/null) )
    	docker rm "${containers[@]}" 2>/dev/null
    	local volumes
    	volumes=( $(docker ps --filter status=exited -q 2>/dev/null) )
    	docker rm -v "${volumes[@]}" 2>/dev/null
    	local images
    	images=( $(docker images --filter dangling=true -q 2>/dev/null) )
    	docker rmi "${images[@]}" 2>/dev/null
    }
    del_stopped(){
    	local name=$1
    	local state
    	state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)
    
    	if [[ "$state" == "false" ]]; then
    		docker rm "$name"
    	fi
    }
    relies_on(){
    	for container in "$@"; do
    		local state
    		state=$(docker inspect --format "{{.State.Running}}" "$container" 2>/dev/null)
    
    		if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
    			echo "$container is not running, starting it for you."
    			$container
    		fi
    	done
    }
   
    #
    # Container Aliases
    #
    audacity(){
    	del_stopped audacity
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e QT_DEVICE_PIXEL_RATIO \
    		--device /dev/snd \
    		--group-add audio \
    		--name audacity \
    		${DOCKER_REPO_PREFIX}/audacity
    }
    aws(){
    	docker run -it --rm \
    		-v "${HOME}/.aws:/root/.aws" \
    		--log-driver none \
    		--name aws \
    		${DOCKER_REPO_PREFIX}/awscli "$@"
    }
    bees(){
    	docker run -it --rm \
    		-e NOTARY_TOKEN \
    		-v "${HOME}/.bees:/root/.bees" \
    		-v "${HOME}/.boto:/root/.boto" \
    		-v "${HOME}/.dev:/root/.ssh:ro" \
    		--log-driver none \
    		--name bees \
    		${DOCKER_REPO_PREFIX}/beeswithmachineguns "$@"
    }
    cadvisor(){
    	docker run -d \
    		--restart always \
    		-v /:/rootfs:ro \
    		-v /var/run:/var/run:rw \
    		-v /sys:/sys:ro  \
    		-v /var/lib/docker/:/var/lib/docker:ro \
    		-p 1234:8080 \
    		--name cadvisor \
    		google/cadvisor
    
    	hostess add cadvisor "$(docker inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' cadvisor)"
    	browser-exec "http://cadvisor:8080"
    }
    cheese(){
    	del_stopped cheese
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-v "${HOME}/Pictures:/root/Pictures" \
    		--device /dev/video0 \
    		--device /dev/snd \
    		--device /dev/dri \
    		--name cheese \
    		${DOCKER_REPO_PREFIX}/cheese
    }
    chrome(){
    	# add flags for proxy if passed
    	local proxy=
    	local map
    	local args=$*
    	if [[ "$1" == "tor" ]]; then
    		relies_on torproxy
    
    		map="MAP * ~NOTFOUND , EXCLUDE torproxy"
    		proxy="socks5://torproxy:9050"
    		args="https://check.torproject.org/api/ip ${*:2}"
    	fi
    
    	del_stopped chrome
    
    	# one day remove /etc/hosts bind mount when effing
    	# overlay support inotify, such bullshit
    	docker run -d \
    		--memory 3gb \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-v "${HOME}/Downloads:/root/Downloads" \
    		-v "${HOME}/Pictures:/root/Pictures" \
    		-v "${HOME}/Torrents:/root/Torrents" \
    		-v "${HOME}/.chrome:/data" \
    		-v /dev/shm:/dev/shm \
    		-v /etc/hosts:/etc/hosts \
    		--security-opt seccomp:/etc/docker/seccomp/chrome.json \
    		--device /dev/snd \
    		--device /dev/dri \
    		--device /dev/video0 \
    		--device /dev/usb \
    		--device /dev/bus/usb \
    		--group-add audio \
    		--group-add video \
    		--name chrome \
    		${DOCKER_REPO_PREFIX}/chrome --user-data-dir=/data \
    		--proxy-server="$proxy" \
    		--host-resolver-rules="$map" "$args"
    
    }
    consul(){
    	del_stopped consul
    
    	# check if we passed args and if consul is running
    	local state
    	state=$(docker inspect --format "{{.State.Running}}" consul 2>/dev/null)
    	if [[ "$state" == "true" ]] && [[ "$*" != "" ]]; then
    		docker exec -it consul consul "$@"
    		return 0
    	fi
    
    	docker run -d \
    		--restart always \
    		-v "${HOME}/.consul:/etc/consul.d" \
    		-v /var/run/docker.sock:/var/run/docker.sock \
    		--net host \
    		-e GOMAXPROCS=2 \
    		--name consul \
    		${DOCKER_REPO_PREFIX}/consul agent \
    		-bootstrap-expect 1 \
    		-config-dir /etc/consul.d \
    		-data-dir /data \
    		-encrypt "$(docker run --rm ${DOCKER_REPO_PREFIX}/consul keygen)" \
    		-ui-dir /usr/src/consul \
    		-server \
    		-dc neverland \
    		-bind 0.0.0.0
    
    	hostess add consul "$(docker inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' consul)"
    	browser-exec "http://consul:8500"
    }
    dcos(){
    	docker run -it --rm \
    		-v "${HOME}/.dcos:/root/.dcos" \
    		-v "$(pwd):/root/apps" \
    		-w /root/apps \
    		${DOCKER_REPO_PREFIX}/dcos-cli "$@"
    }
    firefox(){
    	del_stopped firefox
    
    	docker run -d \
    		--memory 2gb \
    		--net host \
    		--cpuset-cpus 0 \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-v "${HOME}/.firefox/cache:/root/.cache/mozilla" \
    		-v "${HOME}/.firefox/mozilla:/root/.mozilla" \
    		-v "${HOME}/Downloads:/root/Downloads" \
    		-v "${HOME}/Pictures:/root/Pictures" \
    		-v "${HOME}/Torrents:/root/Torrents" \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		--device /dev/snd \
    		--device /dev/dri \
    		--name firefox \
    		${DOCKER_REPO_PREFIX}/firefox "$@"
    
    	# exit current shell
    	exit 0
    }
    gcalcli(){
    	docker run --rm -it \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v "${HOME}/.gcalcli/home:/home/gcalcli/home" \
    		-v "${HOME}/.gcalcli/work/oauth:/home/gcalcli/.gcalcli_oauth" \
    		-v "${HOME}/.gcalcli/work/gcalclirc:/home/gcalcli/.gcalclirc" \
    		--name gcalcli \
    		${DOCKER_REPO_PREFIX}/gcalcli "$@"
    }
    dgcloud(){
    	docker run --rm -it \
    		-v "${HOME}/.gcloud:/root/.config/gcloud" \
    		-v "${HOME}/.ssh:/root/.ssh:ro" \
    		-v "$(which docker):/usr/bin/docker" \
    		-v /var/run/docker.sock:/var/run/docker.sock \
    		--name gcloud \
    		${DOCKER_REPO_PREFIX}/gcloud "$@"
    }
    gimp(){
    	del_stopped gimp
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-v "${HOME}/Pictures:/root/Pictures" \
    		-v "${HOME}/.gtkrc:/root/.gtkrc" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		--name gimp \
    		${DOCKER_REPO_PREFIX}/gimp
    }
    gitsome(){
    	docker run --rm -it \
    		-v /etc/localtime:/etc/localtime:ro \
    		--name gitsome \
    		--hostname gitsome \
    		-v "${HOME}/.gitsomeconfig:/home/anon/.gitsomeconfig" \
    		-v "${HOME}/.gitsomeconfigurl:/home/anon/.gitsomeconfigurl" \
    		${DOCKER_REPO_PREFIX}/gitsome
    }
    hollywood(){
    	docker run --rm -it \
    		--name hollywood \
    		${DOCKER_REPO_PREFIX}/hollywood
    }
    htop(){
    	docker run --rm -it \
    		--pid host \
    		--net none \
    		--name htop \
    		${DOCKER_REPO_PREFIX}/htop
    }
    http(){
    	docker run -t --rm \
    		-v /var/run/docker.sock:/var/run/docker.sock \
    		--log-driver none \
    		${DOCKER_REPO_PREFIX}/httpie "$@"
    }
    imagemin(){
    	local image=$1
    	local extension="${image##*.}"
    	local filename="${image%.*}"
    
    	docker run --rm -it \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v "${HOME}/Pictures:/root/Pictures" \
    		${DOCKER_REPO_PREFIX}/imagemin sh -c "imagemin /root/Pictures/${image} > /root/Pictures/${filename}_min.${extension}"
    }
    irssi() {
    	del_stopped irssi
    	# relies_on notify_osd
    
    	docker run --rm -it \
    		--user root \
    		-v "${HOME}/.irssi:/home/user/.irssi" \
    		${DOCKER_REPO_PREFIX}/irssi \
    		chown -R user /home/user/.irssi
    
    	docker run --rm -it \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v "${HOME}/.irssi:/home/user/.irssi" \
    		--read-only \
    		--name irssi \
    		${DOCKER_REPO_PREFIX}/irssi
    }
    john(){
    	local file
    	file=$(realpath "$1")
    
    	docker run --rm -it \
    		-v "${file}:/root/$(basename "${file}")" \
    		${DOCKER_REPO_PREFIX}/john "$@"
    }
    kernel_builder(){
    	docker run --rm -it \
    		-v /usr/src:/usr/src \
    		--cpu-shares=512 \
    		--name kernel-builder \
    		${DOCKER_REPO_PREFIX}/kernel-builder
    }
    keypassxc(){
    	del_stopped keypassxc
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-v /usr/share/X11/xkb:/usr/share/X11/xkb:ro \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-v /etc/machine-id:/etc/machine-id:ro \
    		--name keypassxc \
    		${DOCKER_REPO_PREFIX}/keepassxc
    }
    kvm(){
    	del_stopped kvm
    	relies_on pulseaudio
    
    	# modprobe the module
    	modprobe kvm
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-v /run/libvirt:/var/run/libvirt \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--link pulseaudio:pulseaudio \
    		-e PULSE_SERVER=pulseaudio \
    		--group-add audio \
    		--name kvm \
    		--privileged \
    		${DOCKER_REPO_PREFIX}/kvm
    }
    libreoffice(){
    	del_stopped libreoffice
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-v "${HOME}/slides:/root/slides" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		--name libreoffice \
    		${DOCKER_REPO_PREFIX}/libreoffice
    }
    lpass(){
    	docker run --rm -it \
    		-v "${HOME}/.lpass:/root/.lpass" \
    		--name lpass \
    		${DOCKER_REPO_PREFIX}/lpass "$@"
    }
    lynx(){
    	docker run --rm -it \
    		--name lynx \
    		${DOCKER_REPO_PREFIX}/lynx "$@"
    }
    masscan(){
    	docker run -it --rm \
    		--log-driver none \
    		--net host \
    		--cap-add NET_ADMIN \
    		--name masscan \
    		${DOCKER_REPO_PREFIX}/masscan "$@"
    }
    mpd(){
    	del_stopped mpd
    
    	# adding cap sys_admin so I can use nfs mount
    	# the container runs as a unpriviledged user mpd
    	docker run -d \
    		--device /dev/snd \
    		--cap-add SYS_ADMIN \
    		-e MPD_HOST=/var/lib/mpd/socket \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /etc/exports:/etc/exports:ro \
    		-v "${HOME}/.mpd:/var/lib/mpd" \
    		-v "${HOME}/.mpd.conf:/etc/mpd.conf" \
    		--name mpd \
    		${DOCKER_REPO_PREFIX}/mpd
    }
    mutt(){
    	# subshell so we dont overwrite variables
    	(
    	local account=$1
    	export IMAP_SERVER
    	export SMTP_SERVER
    
    	if [[ "$account" == "riseup" ]]; then
    		export GMAIL=$MAIL_RISEUP
    		export GMAIL_NAME=$MAIL_RISEUP_NAME
    		export GMAIL_PASS=$MAIL_RISEUP_PASS
    		export GMAIL_FROM=$MAIL_RISEUP_FROM
    		IMAP_SERVER=mail.riseup.net
    		SMTP_SERVER=$IMAP_SERVER
    	fi
    
    	docker run -it --rm \
    		-e GMAIL \
    		-e GMAIL_NAME \
    		-e GMAIL_PASS \
    		-e GMAIL_FROM \
    		-e GPG_ID \
    		-e IMAP_SERVER \
    		-e SMTP_SERVER \
    		-v "${HOME}/.gnupg:/home/user/.gnupg:ro" \
    		-v /etc/localtime:/etc/localtime:ro \
    		--name "mutt-${account}" \
    		${DOCKER_REPO_PREFIX}/mutt
    	)
    }
    ncmpc(){
    	del_stopped ncmpc
    
    	docker run --rm -it \
    		-v "${HOME}/.mpd/socket:/var/run/mpd/socket" \
    		-e MPD_HOST=/var/run/mpd/socket \
    		--name ncmpc \
    		${DOCKER_REPO_PREFIX}/ncmpc "$@"
    }
    neoman(){
    	del_stopped neoman
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--device /dev/bus/usb \
    		--device /dev/usb \
    		--name neoman \
    		${DOCKER_REPO_PREFIX}/neoman
    }
    nes(){
    	del_stopped nes
    	local game=$1
    
    	docker run -d \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--device /dev/dri \
    		--device /dev/snd \
    		--name nes \
    		${DOCKER_REPO_PREFIX}/nes "/games/${game}.rom"
    }
    netcat(){
    	docker run --rm -it \
    		--net host \
    		${DOCKER_REPO_PREFIX}/netcat "$@"
    }
    nginx(){
    	del_stopped nginx
    
    	docker run -d \
    		--restart always \
    		-v "${HOME}/.nginx:/etc/nginx" \
    		--net host \
    		--name nginx \
    		nginx
    
    	# add domain to hosts & open nginx
    	sudo hostess add jess 127.0.0.1
    }
    nmap(){
    	docker run --rm -it \
    		--net host \
    		${DOCKER_REPO_PREFIX}/nmap "$@"
    }
    notify_osd(){
    	del_stopped notify_osd
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		--net none \
    		-v /etc \
    		-v /home/user/.dbus \
    		-v /home/user/.cache/dconf \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--name notify_osd \
    		${DOCKER_REPO_PREFIX}/notify-osd
    }
    alias notify-send=notify_send
    notify_send(){
    	relies_on notify_osd
    	local args=${*:2}
    	docker exec -i notify_osd notify-send "$1" "${args}"
    }
    pandoc(){
    	local file=${*: -1}
    	local lfile
    	lfile=$(readlink -m "$(pwd)/${file}")
    	local rfile
    	rfile=$(readlink -m "/$(basename "$file")")
    	local args=${*:1:${#@}-1}
    
    	docker run --rm \
    		-v "${lfile}:${rfile}" \
    		-v /tmp:/tmp \
    		--name pandoc \
    		${DOCKER_REPO_PREFIX}/pandoc "${args}" "${rfile}"
    }
    pivman(){
    	del_stopped pivman
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--device /dev/bus/usb \
    		--device /dev/usb \
    		--name pivman \
    		${DOCKER_REPO_PREFIX}/pivman
    }
    pms(){
    	del_stopped pms
    
    	docker run --rm -it \
    		-v "${HOME}/.mpd/socket:/var/run/mpd/socket" \
    		-e MPD_HOST=/var/run/mpd/socket \
    		--name pms \
    		${DOCKER_REPO_PREFIX}/pms "$@"
    }
    pond(){
    	del_stopped pond
    	relies_on torproxy
    
    	docker run --rm -it \
    		--net container:torproxy \
    		--name pond \
    		${DOCKER_REPO_PREFIX}/pond
    }
    privoxy(){
    	del_stopped privoxy
    	relies_on torproxy
    
    	docker run -d \
    		--restart always \
    		--link torproxy:torproxy \
    		-v /etc/localtime:/etc/localtime:ro \
    		-p 8118:8118 \
    		--name privoxy \
    		${DOCKER_REPO_PREFIX}/privoxy
    
    	hostess add privoxy "$(docker inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' privoxy)"
    }
    pulseaudio(){
    	del_stopped pulseaudio
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		--device /dev/snd \
    		-p 4713:4713 \
    		--restart always \
    		--group-add audio \
    		--name pulseaudio \
    		${DOCKER_REPO_PREFIX}/pulseaudio
    }
    rainbowstream(){
    	docker run -it --rm \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v "${HOME}/.rainbow_oauth:/root/.rainbow_oauth" \
    		-v "${HOME}/.rainbow_config.json:/root/.rainbow_config.json" \
    		--name rainbowstream \
    		${DOCKER_REPO_PREFIX}/rainbowstream
    }
    registrator(){
    	del_stopped registrator
    
    	docker run -d --restart always \
    		-v /var/run/docker.sock:/tmp/docker.sock \
    		--net host \
    		--name registrator \
    		gliderlabs/registrator consul:
    }
    remmina(){
    	del_stopped remmina
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		-v "${HOME}/.remmina:/root/.remmina" \
    		--name remmina \
    		--net host \
    		${DOCKER_REPO_PREFIX}/remmina
    }
    ricochet(){
    	del_stopped ricochet
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		-e QT_DEVICE_PIXEL_RATIO \
    		--device /dev/dri \
    		--name ricochet \
    		${DOCKER_REPO_PREFIX}/ricochet
    }
    rstudio(){
    	del_stopped rstudio
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-v "${HOME}/fastly-logs:/root/fastly-logs" \
    		-v /dev/shm:/dev/shm \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e QT_DEVICE_PIXEL_RATIO \
    		--device /dev/dri \
    		--name rstudio \
    		${DOCKER_REPO_PREFIX}/rstudio
    }
    s3cmdocker(){
    	del_stopped s3cmd
    
    	docker run --rm -it \
    		-e AWS_ACCESS_KEY="${DOCKER_AWS_ACCESS_KEY}" \
    		-e AWS_SECRET_KEY="${DOCKER_AWS_ACCESS_SECRET}" \
    		-v "$(pwd):/root/s3cmd-workspace" \
    		--name s3cmd \
    		${DOCKER_REPO_PREFIX}/s3cmd "$@"
    }
    scudcloud(){
    	del_stopped scudcloud
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-v /etc/machine-id:/etc/machine-id:ro \
    		-v /var/run/dbus:/var/run/dbus \
    		-v "/var/run/user/$(id -u):/var/run/user/$(id -u)" \
    		-e TERM \
    		-e XAUTHORITY \
    		-e DBUS_SESSION_BUS_ADDRESS \
    		-e HOME \
    		-e QT_DEVICE_PIXEL_RATIO \
    		-v /etc/passwd:/etc/passwd:ro \
    		-v /etc/group:/etc/group:ro \
    		-u "$(whoami)" -w "$HOME" \
    		-v "${HOME}/.Xauthority:$HOME/.Xauthority" \
    		-v /etc/machine-id:/etc/machine-id:ro \
    		-v "${HOME}/.scudcloud:/home/jessie/.config/scudcloud" \
    		--device /dev/snd \
    		--name scudcloud \
    		${DOCKER_REPO_PREFIX}/scudcloud
    
    	# exit current shell
    	exit 0
    }
    shorewall(){
    	del_stopped shorewall
    
    	docker run --rm -it \
    		--net host \
    		--cap-add NET_ADMIN \
    		--privileged \
    		--name shorewall \
    		${DOCKER_REPO_PREFIX}/shorewall "$@"
    }
    skype(){
    	del_stopped skype
    	relies_on pulseaudio
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--link pulseaudio:pulseaudio \
    		-e PULSE_SERVER=pulseaudio \
    		--security-opt seccomp:unconfined \
    		--device /dev/video0 \
    		--group-add video \
    		--group-add audio \
    		--name skype \
    		${DOCKER_REPO_PREFIX}/skype
    }
    slack(){
    	del_stopped slack
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--device /dev/snd \
    		--device /dev/dri \
    		--device /dev/video0 \
    		--group-add audio \
    		--group-add video \
    		-v "${HOME}/.slack:/root/.config/Slack" \
    		--ipc="host" \
    		--name slack \
    		${DOCKER_REPO_PREFIX}/slack "$@"
    }
    spotify(){
    	del_stopped spotify
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e QT_DEVICE_PIXEL_RATIO \
    		--security-opt seccomp:unconfined \
    		--device /dev/snd \
    		--device /dev/dri \
    		--group-add audio \
    		--group-add video \
    		--name spotify \
    		${DOCKER_REPO_PREFIX}/spotify
    }
    ssh2john(){
    	local file
    	file=$(realpath "$1")
    
    	docker run --rm -it \
    		-v "${file}:/root/$(basename "${file}")" \
    		--entrypoint ssh2john \
    		${DOCKER_REPO_PREFIX}/john "$@"
    }
    steam(){
    	del_stopped steam
    	relies_on pulseaudio
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /etc/machine-id:/etc/machine-id:ro \
    		-v /var/run/dbus:/var/run/dbus \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-v "${HOME}/.steam:/home/steam" \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--link pulseaudio:pulseaudio \
    		-e PULSE_SERVER=pulseaudio \
    		--device /dev/dri \
    		--name steam \
    		${DOCKER_REPO_PREFIX}/steam
    }
    t(){
    	docker run -t --rm \
    		-v "${HOME}/.trc:/root/.trc" \
    		--log-driver none \
    		${DOCKER_REPO_PREFIX}/t "$@"
    }
    tarsnap(){
    	docker run --rm -it \
    		-v "${HOME}/.tarsnaprc:/root/.tarsnaprc" \
    		-v "${HOME}/.tarsnap:/root/.tarsnap" \
    		-v "$HOME:/root/workdir" \
    		${DOCKER_REPO_PREFIX}/tarsnap "$@"
    }
    telnet(){
    	docker run -it --rm \
    		--log-driver none \
    		${DOCKER_REPO_PREFIX}/telnet "$@"
    }
    termboy(){
    	del_stopped termboy
    	local game=$1
    
    	docker run --rm -it \
    		--device /dev/snd \
    		--name termboy \
    		${DOCKER_REPO_PREFIX}/nes "/games/${game}.rom"
    }
    tor(){
    	del_stopped tor
    
    	docker run -d \
    		--net host \
    		--name tor \
    		${DOCKER_REPO_PREFIX}/tor
    
    	# set up the redirect iptables rules
    	sudo setup-tor-iptables
    
    	# validate we are running through tor
    	browser-exec "https://check.torproject.org/"
    }
    torbrowser(){
    	del_stopped torbrowser
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		--device /dev/snd \
    		--name torbrowser \
    		${DOCKER_REPO_PREFIX}/tor-browser
    
    	# exit current shell
    	exit 0
    }
    tormessenger(){
    	del_stopped tormessenger
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		--device /dev/snd \
    		--name tormessenger \
    		${DOCKER_REPO_PREFIX}/tor-messenger
    
    	# exit current shell
    	exit 0
    }
    torproxy(){
    	del_stopped torproxy
    
    	docker run -d \
    		--restart always \
    		-v /etc/localtime:/etc/localtime:ro \
    		-p 9050:9050 \
    		--name torproxy \
    		${DOCKER_REPO_PREFIX}/tor-proxy
    
    	hostess add torproxy "$(docker inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' torproxy)"
    }
    traceroute(){
    	docker run --rm -it \
    		--net host \
    		${DOCKER_REPO_PREFIX}/traceroute "$@"
    }
    transmission(){
    	del_stopped transmission
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v "${HOME}/Torrents:/transmission/download" \
    		-v "${HOME}/.transmission:/transmission/config" \
    		-p 9091:9091 \
    		-p 51413:51413 \
    		-p 51413:51413/udp \
    		--name transmission \
    		${DOCKER_REPO_PREFIX}/transmission
    
    
    	hostess add transmission "$(docker inspect --format '{{.NetworkSettings.Networks.bridge.IPAddress}}' transmission)"
    	browser-exec "http://transmission:9091"
    }
    travis(){
    	docker run -it --rm \
    		-v "${HOME}/.travis:/root/.travis" \
    		-v "$(pwd):/usr/src/repo:ro" \
    		--workdir /usr/src/repo \
    		--log-driver none \
    		${DOCKER_REPO_PREFIX}/travis "$@"
    }
    virsh(){
    	relies_on kvm
    
    	docker run -it --rm \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /run/libvirt:/var/run/libvirt \
    		--log-driver none \
    		--net container:kvm \
    		${DOCKER_REPO_PREFIX}/libvirt-client "$@"
    }
    virt_viewer(){
    	relies_on kvm
    
    	docker run -it --rm \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix  \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-v /run/libvirt:/var/run/libvirt \
    		-e PULSE_SERVER=pulseaudio \
    		--group-add audio \
    		--log-driver none \
    		--net container:kvm \
    		${DOCKER_REPO_PREFIX}/virt-viewer "$@"
    }
    alias virt-viewer="virt_viewer"
    visualstudio(){
    	del_stopped visualstudio
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix  \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--device /dev/dri \
    		--name visualstudio \
    		${DOCKER_REPO_PREFIX}/vscode
    }
    alias vscode="visualstudio"
    vlc(){
    	del_stopped vlc
    	relies_on pulseaudio
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		-e GDK_SCALE \
    		-e GDK_DPI_SCALE \
    		-e QT_DEVICE_PIXEL_RATIO \
    		--link pulseaudio:pulseaudio \
    		-e PULSE_SERVER=pulseaudio \
    		--group-add audio \
    		--group-add video \
    		-v "${HOME}/Torrents:/home/vlc/Torrents" \
    		--device /dev/dri \
    		--name vlc \
    		${DOCKER_REPO_PREFIX}/vlc
    }
    watchman(){
    	del_stopped watchman
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v "${HOME}/Downloads:/root/Downloads" \
    		--name watchman \
    		${DOCKER_REPO_PREFIX}/watchman --foreground
    }
    weeslack(){
    	del_stopped weeslack
    
    	docker run --rm -it \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v "${HOME}/.weechat:/home/user/.weechat" \
    		--name weeslack \
    		${DOCKER_REPO_PREFIX}/wee-slack
    }
    wireshark(){
    	del_stopped wireshark
    
    	docker run -d \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		-e "DISPLAY=unix${DISPLAY}" \
    		--cap-add NET_RAW \
    		--cap-add NET_ADMIN \
    		--net host \
    		--name wireshark \
    		${DOCKER_REPO_PREFIX}/wireshark
    }
    wrk(){
    	docker run -it --rm \
    		--log-driver none \
    		--name wrk \
    		${DOCKER_REPO_PREFIX}/wrk "$@"
    }
    ykpersonalize(){
    	del_stopped ykpersonalize
    
    	docker run --rm -it \
    		-v /etc/localtime:/etc/localtime:ro \
    		--device /dev/usb \
    		--device /dev/bus/usb \
    		--name ykpersonalize \
    		${DOCKER_REPO_PREFIX}/ykpersonalize bash
    }
    yubico_piv_tool(){
    	del_stopped yubico-piv-tool
    
    	docker run --rm -it \
    		-v /etc/localtime:/etc/localtime:ro \
    		--device /dev/usb \
    		--device /dev/bus/usb \
    		--name yubico-piv-tool \
    		${DOCKER_REPO_PREFIX}/yubico-piv-tool bash
    }
    alias yubico-piv-tool="yubico_piv_tool"
    
    
    ###
    ### Awesome sauce by @jpetazzo
    ###
    command_not_found_handle () {
    	# Check if there is a container image with that name
    	if ! docker inspect --format '{{ .Author }}' "$1" >&/dev/null ; then
    		echo "$0: $1: command not found"
    		return
    	fi
    
    	# Check that it's really the name of the image, not a prefix
    	if docker inspect --format '{{ .Id }}' "$1" | grep -q "^$1" ; then
    		echo "$0: $1: command not found"
    		return
    	fi
    
    	docker run -ti -u "$(whoami)" -w "$HOME" \
    		"$(env | cut -d= -f1 | awk '{print "-e", $1}')" \
    		--device /dev/snd \
    		-v /etc/passwd:/etc/passwd:ro \
    		-v /etc/group:/etc/group:ro \
    		-v /etc/localtime:/etc/localtime:ro \
    		-v /home:/home \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		"${DOCKER_REPO_PREFIX}/${1}" "$@"
    }
fi
