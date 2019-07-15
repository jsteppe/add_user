#!/bin/bash
# Adding OpenVPN user to the system and generate a certificate
# Adding user
echo "Adding user..."
echo ""
# GLOBAL VARS
read -p "Provide a username: " name
# CHECK AVAILABILITY
index=$(grep $name $OVPN_FOLDER/openvpn-ca/keys/index.txt)
avail=$(grep $name /etc/passwd)
OVPN_FOLDER=/home/yusifg
if [ -z  $avail ] or [ -z $index ]; then
        adduser $name
        echo ""
        echo "User Created!"
        echo ""
        cd $OVPN_FOLDER/openvpn-ca/
        source vars              	# Contains variables of its own, thus executed separately
        $OVPN_FOLDER/openvpn-ca/build-key $name
        $OVPN_FOLDER/client-configs/make_config.sh $name
        cp $OVPN_FOLDER/client-configs/files/$name.ovpn $OVPN_FOLDER/
        exit 0
else
        printf "User %s already exists!" $name
        exit 0
fi
