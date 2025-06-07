FROM ubuntu:24.04
LABEL org.opencontainer.image.authors="nwildner"

#Install packages needed and create pi user
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends ca-certificates git lsb-release sudo dialog unzip xmlstarlet gpg gpg-agent iproute2 vim xdg-utils \
    && useradd -d /home/pi -G sudo -m pi \
    && usermod -aG adm,dialout,cdrom,sudo,audio,video,plugdev,games,users pi \
    && echo "pi ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/pi


# Create pi home, install Retropie Basic setup
USER pi
WORKDIR /home/pi
RUN git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git \
    && cd RetroPie-Setup \
    && sudo chmod +x retropie_setup.sh \
    && sudo chmod +x retropie_packages.sh \
    && sudo ./retropie_packages.sh setup basic_install

# APT cleanup
RUN sudo rm -rf /var/lib/apt/lists/*

# Entrypoint will deal with deal with first
# ES initialization and ES launch
COPY entrypoint.sh /home/pi
ENTRYPOINT ["/home/pi/entrypoint.sh"]
