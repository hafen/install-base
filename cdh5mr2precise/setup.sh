#!/bin/bash

# if not specified, tessera user is tessera
export TESSERA_USER=${TESSERA_USER:-tessera}

# misc dependencies
if [ -f ~/.build_setup_done ]
then
   echo "Skipping setup - already done"
else
   sudo apt-get update -q -q
   sudo apt-get install -y sudo vim wget curl git ant maven
   echo "Setup finished..."
   touch ~/.build_setup_done
fi

