FROM ubuntu:18.04

LABEL maintainer="cristiandanielbarbaro@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Server configuration
COPY confs/maps/* /home/linuxgsm/serverfiles/cstrike/maps/
# https://github.com/GameServerManagers/Game-Server-Configs
COPY confs/server.cfg /home/linuxgsm/serverfiles/cstrike/csserver.cfg
# Custom maps
COPY confs/mapcycle.txt /home/linuxgsm/serverfiles/cstrike/mapcycle.txt

RUN apt-get update && \
    # Installing dependences...
    apt-get -y install \
    tar \
    wget \
    curl \
    file \
    bsdmainutils \
    python3 \
    unzip \
    binutils \
    bc \
    jq \
    tmux \
    netcat \
    iproute2 \
    lib32gcc1 \
    lib32stdc++6 && \
    rm -rf /var/lib/apt/lists/* && \
    # Download linuxgsm.sh script.
    wget -O linuxgsm.sh https://linuxgsm.sh && \
    # Add the linuxgsm user
    adduser \
      --disabled-login \
      --disabled-password \
      --shell /bin/bash \
      --gecos "" \
      linuxgsm && \
    usermod -G tty linuxgsm && \
    # Set permissions linuxgsm user in files
    chmod +x /linuxgsm.sh && \
    cp /linuxgsm.sh /home/linuxgsm/linuxgsm.sh && \
    chown -R linuxgsm:linuxgsm /home/linuxgsm

# Set user and workdir linuxgsm environment.
USER linuxgsm
WORKDIR /home/linuxgsm

# Installation of csserver using linuxgsm.
RUN bash linuxgsm.sh csserver && \
    bash csserver auto-install

EXPOSE 27015

VOLUME [ "/home/linuxgsm/serverfiles/cstrike" ]

CMD [ "/home/linuxgsm/csserver", "start" ]
