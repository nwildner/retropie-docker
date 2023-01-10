#!/bin/bash
xhost local:docker
docker run -it --rm -e XDG_RUNTIME_DIR  -e DBUS_SESSION_BUS_ADDRESS \
	-e DISPLAY=unix$DISPLAY \
	-v /dev/bus:/dev/bus -v /dev/input:/dev/input \
	-v /dev/uinput:/dev/uinput -v /dev/event:/dev/event \
	-v /dev/snd:/dev/snd -v /tmp/.X11-unix:/tmp/.X11-unix \
	-v $HOME/Retropie/ROMS/:/home/pi/RetroPie/roms/ \
	-v $HOME/Retropie/BIOS/:/home/pi/RetroPie/BIOS/ \
	-v $HOME/Retropie/es_homedir_config/:/home/pi/.emulationstation/ \
	-v $HOME/Retropie/retroarch_autoconfig/:/opt/retropie/configs/all/retroarch/autoconfig/ \
	-v $HOME/Retropie/es_config/:/opt/retropie/configs/all/emulationstation/ \
	-v /run/user/$(id -u):/run/user/$(id -u) -v /var/run/dbus:/var/run/dbus \
	-v /run/udev:/run/udev -v /var/run/docker.sock:/var/run/docker.sock \
	--device /dev/bus --device /dev/input --device /dev/uinput \
	--device /dev/event --device /dev/snd \
	--privileged retropie-docker
