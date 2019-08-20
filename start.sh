#!/bin/bash

NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "start.sh starting app using DISPLAY= $DISPLAY"
echo "env= $(env)"

cd /app
exec  node worker.js
