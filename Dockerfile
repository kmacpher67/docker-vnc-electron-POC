FROM ubuntu:16.04
ARG NODE_ENV=production
WORKDIR /app
ADD ./apt.pkgs /app
ENV DISPLAY=":3"
ENV NODE_VERSION 10.16.2 
ENV NVM_DIR=/usr/local/nvm  \
    TERM=xterm \
    STARTUPDIR=/app \
    INST_SCRIPTS=/home/electron/install \
    NO_VNC_HOME=/home/electron/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1296 \
    VNC_PW=pinkwall \
    VNC_VIEW_ONLY=false
RUN /usr/bin/apt-get update
RUN /usr/bin/apt-get install --no-install-recommends -y $(cat /app/apt.pkgs)
RUN /usr/bin/apt-get install --no-install-recommends -y supervisor xfce4 xfce4-terminal xfce4-goodies xterm tightvncserver
RUN /usr/bin/apt-get install --no-install-recommends -y libnss-wrapper gettext
RUN apt-get update 
# "Install Chromium Browser"
RUN apt-get install -y chromium-browser chromium-browser-l10n
# Install NVM/NPM scripts 
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
RUN /usr/bin/apt-get install --no-install-recommends -y curl wget ca-certificates
ARG NVM_INSTALL_SCRIPT=https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh
ENV NVM_DIR=/usr/local/nvm
RUN /usr/bin/apt-get update && \
      /usr/bin/wget -O /tmp/nvm_install.sh $NVM_INSTALL_SCRIPT && \
      /bin/mkdir -p $NVM_DIR && \
      /bin/chmod +x /tmp/nvm_install.sh && \
      /tmp/nvm_install.sh && \
      /bin/chmod +x $NVM_DIR/nvm.sh && \
      . $NVM_DIR/nvm.sh && \
      nvm install $NODE_VERSION && \
      nvm alias default $NODE_VERSION && \
      nvm use default
ADD ./nvm.sh /etc/profile.d/nvm.sh
# Create Electron user 
RUN useradd -ms /bin/bash electron
# add node and npm to path so the commands are available    
# RUN /usr/local/nvm/versions/node/v10.16.2/bin/node install -g npm
RUN chmod +x /etc/profile.d/nvm.sh
RUN . /etc/profile.d/nvm.sh
RUN . $NVM_DIR/nvm.sh
RUN chown -R electron /usr/local/nvm
RUN apt-get install -y nodejs npm
# fucking debian installs `node` as `nodejs`
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
# Install electron 
RUN npm install electron@6.0.2 -g
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
ENV HOME=/home/electron
ENV USER=electron
ENV DISPLAY=":3"
ENV VNC_COL_DEPTH=24 
ENV VNC_RESOLUTION=1280x1296  
RUN touch ~/.Xauthority
RUN chown -R electron:electron "/home/electron"
ADD ./_dist /app
COPY ./start.sh /app
RUN chmod +x /app/start.sh
RUN chown -R electron:electron "/app"
RUN chown root:root /usr/local/lib/node_modules/electron/dist/chrome-sandbox
RUN chmod 4755 /usr/local/lib/node_modules/electron/dist/chrome-sandbox
RUN mkdir -p /var/log/supervisord && chown -R electron:electron "/var/log/supervisord"
RUN /bin/rm -rf /var/lib/apt/lists/*
# USER electron
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]


