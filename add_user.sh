#!/bin/bash
# Adding OpenVPN user to the system and generate a certificate
# Check if the argument has been passed
if [ $# -ne 1 ]; then
        echo "Please, specify a single-word username"
        exit 0
fi
# Adding user
echo "Adding user..."
echo ""
# GLOBAL VARS
OVPN_FOLDER= # Add a path for the openvpn installation folder
# CHECK AVAILABILITY
index=$(grep $1 $OVPN_FOLDER/openvpn-ca/keys/index.txt)
avail=$(grep $1 /etc/passwd)
# Check if the vars return zero
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
# If the user is already in the system script prompts you to delete it
elif [ -n $avail ] && [ -n $avail ];then
        echo "User with this name already exists!"
        read -p "Do you really want to replace an existing user? [y/n]" answer
        if [ $answer == y ];then # Thinking about replacing it with "case"
                userdel -r $1
                rm -f $OVPN_FOLDER/openvpn-ca/keys/$1.*
                sed -i "/$1/d" $OVPN_FOLDER/openvpn-ca/keys/index.txt
                echo "User has been deleted from database!"
        else
                exit 0
        fi
fi
