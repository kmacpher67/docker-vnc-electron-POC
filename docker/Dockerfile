FROM ubuntu:16.04
ARG NODE_ENV=production
WORKDIR /app
ADD ./apt.pkgs /app
ENV DISPLAY=":99"
ENV NVM_DIR=/usr/local/nvm  \
    TERM=xterm \
    STARTUPDIR=/app \
    INST_SCRIPTS=/home/electron/install \
    NO_VNC_HOME=/home/electron/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1296 \
    VNC_PW=buildthewall \
    VNC_VIEW_ONLY=false
RUN useradd -ms /bin/bash electron
RUN /usr/bin/apt-get update
RUN /usr/bin/apt-get install --no-install-recommends -y $(cat /app/apt.pkgs)
RUN /usr/bin/apt-get install --no-install-recommends -y supervisor xfce4 xfce4-terminal xfce4-goodies xterm tightvncserver
RUN /usr/bin/apt-get install --no-install-recommends -y libnss-wrapper gettext
# Install NVM/NPM scripts 
RUN apt-get update 
RUN /usr/bin/apt-get install --no-install-recommends -y curl wget ca-certificates
ARG NVM_INSTALL_SCRIPT=https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh
ENV NVM_DIR=/usr/local/nvm
RUN /usr/bin/apt-get update && \
      /usr/bin/wget -O /tmp/nvm_install.sh $NVM_INSTALL_SCRIPT && \
      /bin/mkdir -p $NVM_DIR && \
      /bin/chmod +x /tmp/nvm_install.sh && \
      /tmp/nvm_install.sh && \
      . $NVM_DIR/nvm.sh && \
      nvm install 6.15.1 
# RUN apt-get install npm
# "Install Chromium Browser"
RUN apt-get update 
RUN apt-get install -y chromium-browser chromium-browser-l10n
# Install electron 
# RUN npm install electron -g
# Install & setup of vnc server 
COPY ./vnc_startup.sh /app
RUN /bin/chmod +x /app/vnc_startup.sh
RUN mkdir -p "/home/electron/.vnc"
COPY ./xstartup /home/electron/.vnc/
COPY ./supervisor.conf /etc/supervisor/conf.d
RUN /bin/chmod +x /home/electron/.vnc/xstartup
ENV PASSWD_PATH="/home/electron/.vnc/passwd"
RUN echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
RUN chmod 600 $PASSWD_PATH
COPY ./wm_startup.sh /app
RUN /bin/chmod +x /app/wm_startup.sh
# COPY ./vncserver@.service /etc/systemd/system/vncserver@.service
# RUN mkdir -p /run/dbus
# RUN dbus-daemon --system
ENV HOME=/home/electron
ENV USER=electron
ENV DISPLAY=":99"
ENV VNC_COL_DEPTH=24 
ENV VNC_RESOLUTION=1280x1296 
ENV VNC_PW=buildthewall 
RUN touch ~/.Xauthority
RUN chown -R electron:electron "/home/electron"
ADD ./_dist /app
RUN mkdir -p /var/log/supervisord && chown -R electron:electron "/var/log/supervisord"
RUN /bin/rm -rf /var/lib/apt/lists/*
# USER electron
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]


