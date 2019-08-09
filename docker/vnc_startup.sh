#!/bin/bash
### every exit != 0 fails the script
set -e

echo -e "HOME IS here:  $HOME"
echo -e "DISPLAY=  $DISPLAY"

echo -e "whoami:"+$(whoami)
## change vnc password
echo -e "\n------------------ change VNC password  ------------------"
# first entry is control, second is view (if only one is valid for both)
mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

echo "password" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH

echo -e "\n------------------ start VNC server ------------------------"
echo "remove old vnc locks to be a reattachable container"
# vncserver -kill $DISPLAY &> $HOME/vnc_startup.log \
#    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> $HOME/vnc_startup.log \
#    || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."
# tightvncserver -nolisten tcp -localhost -nevershared $DISPLAY &>$HOME/.vnc/vnc.log

# vncserver $DISPLAY &>$HOME/.vnc/vnc.log
# &>$HOME/no_vnc_startup.log
# &>/tmp/no_vnc_startup.log
#echo -e "start window manager\n..."
#$HOME/wm_startup.sh &> $STARTUPDIR/wm_startup.log

## log connect options
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$VNC_IP:$NO_VNC_PORT/?password=...\n"

echo "LOG DIR= $(ls -ltra /home/electron/.vnc/)" 

cat $HOME/.vnc/vnc.log
ps -ef 

VNC=$(ps -ef | grep Xtightvnc)

# To view a listing of the .Xauthority file, enter the following 
xauth list 

while [ 0==0 ]
do
   sleep 60
   ps -ef 
done
