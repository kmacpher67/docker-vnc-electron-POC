# docker-vnc-electron-POC

Getting an Ubuntu Desktop running inside Docker using VNC for visually inspecting an Electron Chromium page view. 





## ubuntu Desktop shortcuts for building and accessing the container. 


``` 
cd docker
docker build --tag ubuntudesktopcrs:v1 .
export IMAGE_ID=$(docker images | grep -Ei 'ubuntudesktop' | awk '{print $3}')
echo $IMAGE_ID
export CONTAINER_ID=$(docker run -itd --net=host --name ubuntudesktop  $IMAGE_ID)
echo $CONTAINER_ID
docker logs -f  $CONTAINER_ID 

```
### docker exec -it $CONTAINER_ID /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"

# OR as just root 
### docker exec -it $CONTAINER_ID /bin/bash

### Login As electron user. 
docker exec -it $CONTAINER_ID su - electron; /bin/bash


### watch the logs in another window. 
`docker rm -f CONTAINER  $CONTAINER_ID `


## running electron inside the container. 

configure a VNC session into the ":3" display panel (like RDP remote desktop for linux). 
```
$ 
export DISPLAY=":3" 
cd /app
electron main.js 
```


### sample ps command inside the container

```
$ cat pslogs
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 11:52 pts/0    00:00:47 /usr/bin/python /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
root         8     1  0 11:52 pts/0    00:00:00 /usr/bin/Xvfb :99 -screen 0 1024x768x24
electron    21     1  0 11:52 pts/0    00:00:00 Xtightvnc :1 -desktop X -auth /home/electron/.Xauthority -geometry 1024x768 -depth 24 -rfbwait 120000 -rfbauth /home/electron/.vnc/passwd -rfbport 5901 -fp /usr/share/fonts/X11/misc/,/usr/share/fonts/X11/Type1/,/usr/share/fonts/X11/75dpi/,/usr/share/fonts/X11/100dpi/ -co /etc/X11/rgb -nevershared -nolisten tcp -localhost :2
root       142     0  0 11:53 pts/1    00:00:00 /bin/sh -c [ -e /bin/bash ] && /bin/bash || /bin/sh
root       150   142  0 11:53 pts/1    00:00:00 /bin/bash
root      1489 24707  0 15:49 pts/1    00:00:00 /usr/lib/x86_64-linux-gnu/xfce4/panel/wrapper-1.0 /usr/lib/x86_64-linux-gnu/xfce4/panel/plugins/libsystray.so 6 25165858 systray Notification Area Area where notification icons appear
root      1491 24707  0 15:49 pts/1    00:00:00 /usr/lib/x86_64-linux-gnu/xfce4/panel/wrapper-1.0 /usr/lib/x86_64-linux-gnu/xfce4/panel/plugins/libactions.so 2 25165859 actions Action Buttons Log out, lock or other system actions
electron  2330     1  4 15:53 pts/0    00:00:00 /usr/bin/perl /usr/bin/tightvncserver -nolisten tcp -localhost -nevershared :2
electron  2339 32101  0 15:53 pts/1    00:00:00 ps -ef
message+ 13001     1  0 14:29 ?        00:00:00 dbus-daemon --system
root     24642     1  0 15:14 pts/1    00:00:00 Xtightvnc :3 -desktop X -auth /root/.Xauthority -geometry 1024x768 -depth 24 -rfbwait 120000 -rfbauth /root/.vnc/passwd -rfbport 5903 -fp /usr/share/fonts/X11/misc/,/usr/share/fonts/X11/Type1/,/usr/share/fonts/X11/75dpi/,/usr/share/fonts/X11/100dpi/ -co /etc/X11/rgb -nolisten tcp -localhost :3
root     24647     1  0 15:14 pts/1    00:00:00 /bin/sh /root/.vnc/xstartup
root     24650 24647  0 15:14 pts/1    00:00:00 /bin/sh /etc/xdg/xfce4/xinitrc
root     24675     1  0 15:14 pts/1    00:00:00 /usr/bin/dbus-launch --exit-with-session x-session-manager
root     24676     1  0 15:14 ?        00:00:00 /usr/bin/dbus-daemon --fork --print-pid 5 --print-address 7 --session
root     24687 24650  0 15:14 pts/1    00:00:00 xfce4-session
root     24691     1  0 15:14 ?        00:00:00 /usr/lib/x86_64-linux-gnu/xfce4/xfconf/xfconfd
root     24701     1  0 15:14 pts/1    00:00:00 xfwm4
root     24707     1  0 15:14 pts/1    00:00:00 xfce4-panel
root     24710     1  0 15:14 pts/1    00:00:00 Thunar --daemon
root     24712     1  0 15:14 pts/1    00:00:00 xfdesktop
root     32100   150  0 15:43 pts/1    00:00:00 su - electron
electron 32101 32100  0 15:43 pts/1    00:00:00 -su
```


### notes: 

npm install electron -g


See your dev dependency list here (for electron): 
https://github.com/electron/electron/blob/master/build/install-build-deps.sh

