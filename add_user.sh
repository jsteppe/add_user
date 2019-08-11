#!/bin/bash
# By Yusif Galabayli
# GLOBAL VARIABLES
OVPN_FOLDER=<your openvpn installation folder>
GREEN='\e[32m'
BOLD='\e[1m'
RED='\e[91m'
DEFAULT='\e[0m'
# Check Executing User
if [[ "$EUID" -ne 0 ]]; then
        echo -e "${RED}Sorry, you need to run this as root${DEFAULT}"
        exit 0
fi

# Check if BASH is used
if readlink /proc/$$/exe | grep -q "dash"; then
        echo "This script needs to be run with bash"
        exit 0
fi

# Adding user
if    [ $# -ne 1 ]; then
        echo -e "${RED}Please, specify a single-word username${DEFAULT}"
        exit 0
fi

echo -e "Welcome to ${BOLD}OpenVPN${DEFAULT}"
echo "Adding user..."
echo ""
# CHECK AVAILABILITY
index=$(grep $1 $OVPN_FOLDER/openvpn-ca/keys/index.txt)
avail=$(grep $1 /etc/passwd)
if [[ -z $avail && -z $index ]]; then
        adduser $1
        echo ""
        echo -e "${GREEN}User Created!${DEFAULT}"
        echo ""
        cd $OVPN_FOLDER/openvpn-ca/
        source vars
        $OVPN_FOLDER/openvpn-ca/build-key $1
        $OVPN_FOLDER/client-configs/make_config.sh $1
        cp $OVPN_FOLDER/client-configs/files/$1.ovpn $OVPN_FOLDER/
        echo -e "${GREEN}You're all done!${DEFAULT}"
        exit 0
elif [[ -n $avail && -n $avail ]];then
        echo "User with this name already exists!"
        read -p "Do you really want to replace an existing user? [y/n] " answer
        case $answer in
                y | Y | "yes" | "YES" | "Yes") userdel -r $1
                   rm -f $OVPN_FOLDER/openvpn-ca/keys/$1.*
                   sed -i "/$1/d" $OVPN_FOLDER/openvpn-ca/keys/index.txt
                   echo -e "${GREEN}User has been deleted from database!${DEFAULT}"
                   exit 0
                   ;;
                *) exit 0
        esac
fi
