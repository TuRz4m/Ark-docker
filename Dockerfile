FROM cm2network/steamcmd:root

LABEL maintainer="wollsi"

# Var for first config
# Server Name
ENV SESSIONNAME "ArkServer"
# Map name
ENV SERVERMAP "TheIsland"
# Server password
ENV SERVERPASSWORD ""
# Admin password
ENV ADMINPASSWORD "adminpassword"
# Nb Players
ENV NBPLAYERS 70
# If the server is updating when start with docker start
ENV UPDATEONSTART 1
# if the server is backup when start with docker start
ENV BACKUPONSTART 1
# Query port for Steam's server browser
ENV QUERYPORT 27015
# Game client port
ENV GAMEPORT 7777
# RCON port
ENV RCONPORT 27020
# if the server should backup after stopping
ENV BACKUPONSTOP 0
# If the server warn the players before stopping
ENV WARNONSTOP 0
# UID of the user steam
ENV UID 1000
# GID of the user steam
ENV GID 1000

# ------------------------ #
# Install ark-server-tools #
# ------------------------ #

# Install dependencies for ark-server-tools (see: https://github.com/arkmanager/ark-server-tools#prerequisites)
RUN apt-get update && \
	apt-get install -y \
		perl-modules \
		curl \
		lsof \
		libc6-i386 \
		lib32gcc1 \
		bzip2

RUN curl -sL https://git.io/arkmanager | bash -s steam

# Allow crontab to call arkmanager
RUN ln -s /usr/local/bin/arkmanager /usr/bin/arkmanager

# ----------------- #
# Prepare container #
# ----------------- #

# create directories
RUN mkdir /ark
RUN chown steam -R /ark && chmod 755 -R /ark

# Copy system config file to /etc/arkmanager
COPY arkmanager-system.cfg /etc/arkmanager/arkmanager.cfg

# Copy temporary files to /home/steam
COPY instance.cfg /home/steam/main.cfg
COPY arkmanager-user.cfg /home/steam/arkmanager.cfg
COPY crontab /home/steam/crontab

# Copy scripts
COPY run.sh /home/steam/run.sh
COPY user.sh /home/steam/user.sh

# Fix rights
RUN touch /root/.bash_profile
RUN chmod 777 /home/steam/run.sh
RUN chmod 777 /home/steam/user.sh

# ------------------- #
# Configure container #
# ------------------- #

EXPOSE ${GAMEPORT}/udp
EXPOSE ${QUERYPORT}/udp
# optional:
EXPOSE ${RCONPORT}

VOLUME /ark

# Change the working directory to /ark
WORKDIR /ark

ENTRYPOINT ["/home/steam/user.sh"]
