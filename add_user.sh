#!/bin/bash
# Adding OpenVPN user to the system and generate a certificate
# Adding user
echo "Adding user..."
echo ""
# GLOBAL VARS
#read -p "Provide a username: " name
# CHECK AVAILABILITY
index=$(grep $1 $OVPN_FOLDER/openvpn-ca/keys/index.txt)
avail=$(grep $1 /etc/passwd)
OVPN_FOLDER=/home/yusifg
if [ -z  $avail ] or [ -z $index ]; then
        adduser $1
        echo ""
        echo "User Created!"
        echo ""
        cd $OVPN_FOLDER/openvpn-ca/
        source vars              	# Contains variables of its own, thus executed separately
        $OVPN_FOLDER/openvpn-ca/build-key $1
        $OVPN_FOLDER/client-configs/make_config.sh $1
        cp $OVPN_FOLDER/client-configs/files/$1.ovpn $OVPN_FOLDER/
        exit 0
else
        printf "User %s already exists!" $1
        exit 0
fi
