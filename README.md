Initialize User
===============

Introduction
------------
This script was made to create users on aws ec2 (Ubuntu) with an existing authorization 
key and assumes <Keypair.pem> is located in the ``.ssh`` local directory.

Usage
-----
Before running ``inituser.sh`` on your local machine, be sure the script is made 
executable by typing in ``chmod +x inituser.sh``

``./inituser [keypair.pem]... [Public DNS (IPv4)]...``


Default port is 22.
