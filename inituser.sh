#!/bin/bash

# Author: Charles Petchsy
# Date: May 9, 2017

# This script is only to be used when creating users on ec2 (Ubuntu) with an
# existing authorization key
# Default port is 22.

# Standard error checking
if [ $1 = "--help" ]; then
  echo "-----------------------------------------------------------------------"
  echo "It will add a user and create an authorized_keys file with the proper" 
  echo "chmod permission flags. The public key is then copied over to the newly" 
  echo "created user to match the keypair."
  echo "-----------------------------------------------------------------------"
  echo "Be sure the <Keypair>.pem file has proper permission flags"
  echo "--> Run 'sudo chmod 600' on your <Keypair>.pem"
  echo " "
  exit 1
elif [ "$#" -ne 2 ]; then
  echo "Usage: $0 [<Keypair>.pem location] [Public DNS (IPv4)]" >&2
  echo "	Example: $0 <Keypair>.pem ubuntu@ec2.compute.amazonaws.com"
  exit 1
fi

read -p "Name of new user: " NEW_USER

MY_KEY=$1
ec2=$2

if [ ! -e $MY_KEY ]; then
    echo "ERROR: `basename $MY_KEY` does not exist."
    echo "Exiting..."
    exit 1
fi

echo "Logging into EC2..."
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
cat /home/$USER/.ssh/authorized_keys > /home/$NEW_USER/.ssh/authorized_keys
exit
echo "Done!"

echo "Now Exiting."
exit
!

echo " "
echo "$NEW_USER has been created!"
