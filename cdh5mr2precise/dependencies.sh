#!/bin/bash

sudo apt-get update -q -q
sudo apt-get dist-upgrade --yes --force-yes

sudo apt-get update -q -q
sudo apt-get install -y sudo vim wget curl git ant maven
