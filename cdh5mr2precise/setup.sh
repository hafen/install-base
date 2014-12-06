#!/bin/bash

# if not specified, tessera user is tessera
export TESSERA_USER=${TESSERA_USER:-tessera}

# misc dependencies
if [[ $BUILD_SETUP_DONE && ${BUILD_SETUP_DONE-_} ]]
then
   echo "Skipping setup - already done"
else
   sudo apt-get update -q -q
   sudo apt-get install -y sudo vim wget curl git ant maven
   echo "Setup finished..."
   export BUILD_SETUP_DONE=1
fi

