Amazon Web Services Utility Belt
================================

Before running the scripts on your local machine, be sure the script is made 
executable with ``chmod +x``

Initialize User (inituser.sh)
-----------------------------
This script was made to create users on aws EC2 (Ubuntu) with an existing authorization 
key. It will add a user and create an authorized_keys file with the proper ``chmod`` 
permission flags. The public key is then copied over to the newly created user to match the keypair.

On create, passwords are disabled but the new user can set their password with ``passwd``.

``./inituser.sh [keypair.pem location] [Public DNS (IPv4)]``

You will be prompted to type in the name of the new user you wish to add to your EC2.

Create Database (createDB.sh)
-----------------------------
This script will initialize and run the following APIs: MongoDB, BigchainDB, and additional python drivers.

``./createDB.sh [keypair.pem location] [Public DNS (IPv4)]``
