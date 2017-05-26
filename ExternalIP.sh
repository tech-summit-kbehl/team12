#! /bin/bash

echo "Enter VM IP Address:"

read VMIPADDRESS

echo "Enter External Data Services IP Address:"

read NEWIP

curl --insecure -X PUT -H "Content-Type: application/json" -u admin:nutanix/4u -H "Cache-Control: no-cache" -d "{\"name\": \"Unnamed\", \"clusterExternalIPAddress\": null, \"clusterExternalDataServicesIPAddress\": \"$NEWIP\"}" "https://$VMIPADDRESS:9440/PrismGateway/services/rest/v1/cluster"