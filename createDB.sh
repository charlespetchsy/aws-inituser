#!/bin/bash

# Author: Charles Petchsy

# This script installs MongoDB, Bigchaindb, and python driver
# on the current EC2 (Ubuntu)

# Standard error checking
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 [<Keypair>.pem location] [Public DNS (IPv4)]" >&2
  echo "	Example: $0 <Keypair>.pem ubuntu@ec2.compute.amazonaws.com"
  exit 1
fi

MY_KEY=$1
ec2=$2

if [ ! -e $MY_KEY ]; then
    echo "ERROR: `basename $MY_KEY` does not exist."
    echo "Exiting..."
    exit 1
fi

ssh -i $MY_KEY $ec2 << !
echo "Checking for updates..."
sudo apt-get update ; sudo apt-get upgrade

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update

echo "Installing Mongodb..."
sudo apt-get install -y mongodb-org
sudo mkdir /data ; sudo mkdir /data/db
sudo chmod 766 /data ; sudo chmod 666 /data/db
sudo mongod

mongod --replSet=bigchain-rs
sudo apt-get update
sudo apt-get install g++ python3-dev libffi-dev

# Get the latest version of pip and setuptools
sudo apt-get install python3-pip
sudo pip3 install --upgrade pip setuptools

# Install the bigchaindb Python package from PyPI
sudo pip3 install bigchaindb
bigchaindb -y configure mongodb

!

echo " "
echo "Installation Successful!"