#!/bin/bash


# Test an IP address for validity:
# Usage:
#      valid_ip IP_ADDRESS
#      if [[ $? -eq 0 ]]; then echo good; else echo bad; fi
#   OR
#      if valid_ip IP_ADDRESS; then echo good; else echo bad; fi
#
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


# Ask for Number of VMs?
NumberVMs=100
i=0
declare -a OSName
declare -a IPA
read -p 'Number of VMs to deploy?' NumberVMs
while [[ $i < $NumberVMs ]]
do
	let i=i+1
	validIP=0
	echo "Please enter information for VM" $i
	# Ask for GuestOS Name
	read -p 'Guest OS Name: ' OSName[$i]
	# Ask for IP Address
	while [ $validIP = 0 ]
	do
	read -p 'IP Address: ' IPA[$i]
	 
	 IPtest=${IPA[$i]}
	 
	 if valid_ip $IPtest; then validIP=1 ; else echo Please enter valid IP address; fi
	 
	done
#   
	echo
done
