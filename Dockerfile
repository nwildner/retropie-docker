FROM ubuntu:22.04
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get upgrade \
    && apt-get install -y --no-install-recommends ca-certificates git lsb-release sudo dialog unzip xmlstarlet gpg gpg-agent iproute2 vim less \
    && useradd -d /home/pi -G sudo -m pi \
    && echo "pi ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pi

RUN usermod -aG adm,dialout,cdrom,sudo,audio,video,plugdev,games,users pi

USER pi
WORKDIR /home/pi
RUN git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git \
    && cd RetroPie-Setup \
    && sudo chmod +x retropie_setup.sh \
    && sudo ./retropie_packages.sh setup basic_install

RUN sudo rm -rf /var/lib/apt/lists/*

#ENTRYPOINT "/usr/bin/emulationstation"
CMD "#auto"
