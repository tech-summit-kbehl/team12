#!/bin/bash
clear
Echo This script will create a /24 Network with DHCP enabled.
Echo You will be asked for a gateway IP address, DNS server IP address, Network Address and usable IP range, network name and VLAN ID.
read -p "Press ENTER to continue"
clear

Echo Please enter a name for your network [example: My_Fancy_Network]:
read netname
Echo Please enter the VLAN ID for your new network [example: 76]:
read vlanid
Echo Please enter the Network address for your new network [example: 10.10.10.0]:
read netaddress
Echo Please enter the default gateway address for your new network [example: 10.10.10.1]:
read gateway
Echo Please enter the DNS server address for your new network [example: 8.8.8.8]:
read dnsip
Echo Please enter the LOWER IP address of your DHCP range: [example: 10.10.10.50]:
read lowrange
Echo Please enter the UPPER IP address of your DHCP range: [example: 10.10.10.100]:
read highrange


range="$lowrange $highrange"
echo This is what you  entered:
echo VLAN ID: $vlanid
echo Network Name: $netname
echo Network Address: $netaddress
echo Gateway: $gateway
echo DNS IP: $dnsip
echo IP Range: $lowrange - $highrange
echo Range var: $range

read -p "Ready? - Press ENTER"







  curl --insecure -X POST https://10.68.69.102:9440/api/nutanix/v2.0/networks/ -H 'cache-control: no-cache' -H 'content-type: application/json' -u admin:nutanix/4u -d "{\"ip_config\": {\"default_gateway\": \"$gateway\",\"dhcp_options\": {\"domain_name_servers\": \"$dnsip\"},\"network_address\": \"$netaddress\",\"pool\": [{\"range\": \"$range\"}],\"prefix_length\": 24},\"name\": \"$netname\",\"vlan_id\": \"$vlanid\" }"
