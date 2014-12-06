#!/bin/bash

# if not specified, tessera user is tessera
export TESSERA_USER=${TESSERA_USER:-tessera}

# misc dependencies
if [[ $BUILD_SETUP_DONE && ${BUILD_SETUP_DONE-_} ]]
   then
      sudo apt-get update -q -q
      sudo apt-get install -y sudo vim wget curl git ant maven
      export BUILD_SETUP_DONE=1
   else
      echo "Skipping setup - already done"
fi

