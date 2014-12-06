#!/bin/bash

# if not specified, tessera user is tessera
export TESSERA_USER=${TESSERA_USER:-tessera}

# misc dependencies
sudo apt-get update -q -q
sudo apt-get install -y sudo vim wget curl git ant maven
