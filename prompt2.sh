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


VMName="defaultName"
IPAddres="0.0.0.0"
echo "VM name is $VMName"
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
	VMName=${OSName[$i]}
	echo "Inside loop $VMName"
	# Ask for IP Address
	while [ $validIP = 0 ]
	do
	read -p 'IP Address: ' IPA[$i]
	 
	 IPtest=${IPA[$i]}
	IPAddress=$IPtest 
	 if valid_ip $IPtest; then validIP=1 ; else echo Please enter valid IP address; fi
	 
	done
done   
	echo
i=0
while [[ $i < $NumberVMs ]]
do
let i=i+1
`curl --insecure -s --output /dev/null  -X POST \
  https://10.68.69.102:9440/api/nutanix/v2.0/vms/ \
  -H 'authorization: Basic YWRtaW46bnV0YW5peC80dQ==' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 8a4f9829-8abc-caaa-ebe0-ff79d017dafb' \
  -d '{
        "description": "CentOS VM",
        "guest_os": "CentOS 7",
        "memory_mb": 1024,
        "name": "'"${OSName[$i]}"'",
        "num_cores_per_ vcpu": 1,
        "num_vcpus": 2,
        "vm_disks": [{
                "disk_address": {
                        "device_bus": "ide",
                        "device_index": 0
                },
                "is_cdrom": false,
                "is_empty": false,
                "vm_disk_clone": {
                        "disk_address": {
                                "vmdisk_uuid": "75099126-fd16-4e4b-8d02-a51172222a15"
                        }
                }
        }, {
                "disk_address": {
                        "device_bus": "scsi",
                        "device_index": 0
                },
                "vm_disk_create": {
                        "storage_container_uuid": "8fefcdd7-420a-4c5e-a477-d6bcaa6fae52",
                        "size": 10737418240
                }
        }, {
                "disk_address": {
                        "device_bus": "ide",
                        "device_index": 1
                },
                "is_ cdrom": true,
                "is_empty": false,
                "vm_disk_clone": {
                        "disk_address": {
                                "vmdisk_uuid": "55fdd0be-7725-4205-b1f9-ac6868c4fab3"
                        }
                }
        }],
      "vm_nics": [
        {
          "network_uuid": "68968a61-d26d-4949-9a44-0616a4e9b087",
          "request_ip": true,
          "requested_ip_address": "'"${IPA[$i]}"'"
        }
      ],
        "hypervisor_type": "ACROPOLIS",
        "affinity": null
}'
`

done
    echo

sleep 30


#echo "second $OSName"
echo "Powering on VMs"
i=0
while [[ $i < $NumberVMs ]]
do
 let i=i+1
 echo $OSName[$i]
#echo "DEBUG source /etc/profile ; acli vm.on $VMName"
 ssh nutanix@10.68.69.102 "source /etc/profile ; acli vm.on ${OSName[$i]}"

 sleep 30
 echo ${IPA[$i]}
#echo $IPAddress
 #echo "DEBUG root@$IPAddress" 
 ssh root@${IPA[$i]} "hostname ${OSName[$i]}; yum -y install update ; hostname"

done

echo "Done!"
