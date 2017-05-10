#!/bin/bash

# Author: Charles Petchsy
# Date: May 9, 2017

# This script is only to be used when creating users on ec2 (Ubuntu) with an
# existing authorization key
# Assumes <Keypair.pem> in located in the .ssh directory

# Default port is 22.

# Standard error checking
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 [Keypair name] [Public DNS (IPv4)]" >&2
  echo "	Example: $0 <Keypair>.pem ubuntu@ec2.compute.amazonaws.com"
  exit 1
fi

read -p "ENTER NAME OF NEW USER: " NEW_USER

MY_KEY=$1
ec2=$2

cd ~/.ssh/

echo "Logging into ec2..."
ssh -i $MY_KEY $ec2 << !
# Create user and removes password and user interactive prompt
sudo adduser --disabled-password --force-badname --gecos "" $NEW_USER

echo "Creating authorized_keys file for $NEW_USER ..."
# Set the appropriate permission flags
sudo su - $NEW_USER
mkdir .ssh ; chmod 700 .ssh
touch .ssh/authorized_keys ; chmod 600 .ssh/authorized_keys
exit
echo "Done!"
echo ...
echo "Copying over public key..."
sudo su
cat /home/ubuntu/.ssh/authorized_keys > /home/$NEW_USER/.ssh/authorized_keys
exit
echo "Done!"

echo "Now Exiting."
exit

!