# retropie-docker
Docker resources to run Retropie Install script as a container, and game using Retropie on Linux without the need of dual-boot

Note that it is implicit that you might need to have docker daemon already running, or any additional software that is capable of handling docker images like `podman`(`podman-docker` might also be handy to help with cli syntax)

# How to build the image

    git clone --depth=1 https://github.com/nwildner/retropie-docker.git
    cd retropie-docker
    docker build -t retropie-docker .

This will build an image that is currently based on Ubuntu LTS 22.04 from official docker images because, this is a requisite for Retropie. Needs further testing if this could be done with a Debian image as well.

# Running a container instance of this image

I'm creating a bunch of dirs here that will be further mapped to critical configuration directories inside the container so, this configuration can persist across rebots

    $ cd ~
    $ mkdir -p Retropie/{es_config,es_homedir_config,retroarch_autoconfig}
    $ xhost local:docker
    $ docker run -it --rm -e XDG_RUNTIME_DIR  -e DBUS_SESSION_BUS_ADDRESS -e DISPLAY=unix$DISPLAY \
        -v /dev/bus:/dev/bus -v /dev/input:/dev/input -v /dev/snd:/dev/snd  -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v $HOME/ROMS/:/home/pi/RetroPie/roms/ \
        -v $HOME/Retropie/es_homedir_config/:/home/pi/.emulationstation/ \
        -v $HOME/Retropie/retroarch_autoconfig/:/opt/retropie/configs/all/retroarch/autoconfig/ \
        -v $HOME/Retropie/es_config/:/opt/retropie/configs/all/emulationstation/ \
        -v /run/user/$(id -u):/run/user/$(id -u) \
        -v /var/run/dbus:/var/run/dbus -v /var/run/docker.sock:/var/run/docker.sock \
        --device /dev/input --device /dev/snd --privileged retropie-docker bash

Replace `COMMAND` with `bash` or `emulationstation` depending on what software you want to run fron inside the container. This might change in the future(check Issues title below). The ROMS dir which is passed as an argument to `docker run` should also be configured to a location on your machine that makes sense(holding your Rom files).

**NOTE** = Before running `emulationstation` for the first time, reset the controller config otherwise, the `retroarch` mapping file won't be created inside `/opt/retropie/configs/all/retroarch/autoconfig/`

    $ cd Retropie-Setup
    $ sudo ./retropie_setup.sh
        Configuration / Tools
        emulationstation
        Clear/Reset Emulation Station input configuration

The line that maps `es_input.cfg` on the container was set to accelerate Emulationstation start and avoid asking for controller configuration since, Retropie still relies on the player setting up the controller for the first time, unlike Batocera or Recalbox...

# Currently known issues

While EmulationStation is able to generate a new configuration files for controllers inside `$HOME/.emulationstaion/es_input.cfg` of the container and retroarch configuration inside `/opt/retropie/configs/all`, the controller is dead while the emulator is runnig but, as soon as the retroarch process is finished, controller gets back to work on ES
