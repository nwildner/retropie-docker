#!/bin/sh
# This script checks if the container is started for the first time.

#HOME and Local Emulationstation configs
PIUSER_HOME="/home/pi"
ESUSER_HOME="$PIUSER_HOME/.emulationstation"

#RetroPie directory and Setup directory
RETROPIE_HOME="/home/pi/RetroPie"
RETROPIE_SETUP="/$RETROPIE_HOME-Setup"

#File inside local emulationstation directory indicating first run
CONTAINER_FIRST_STARTUP="$ESUSER_HOME/firstrun"

if [ ! -e $CONTAINER_FIRST_STARTUP ]; then
    sudo $RETROPIE_SETUP/retropie_packages.sh emulationstation clear_input
    touch $CONTAINER_FIRST_STARTUP
fi

emulationstation
#bash
