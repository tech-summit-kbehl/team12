#!/bin/bash

Echo ——————————————————
Echo Virtual Machines
Echo ——————————————————

curl -s --insecure -X GET   https://10.68.69.102:9440/PrismGateway/services/rest/v2.0/vms/   -H 'cache-control: no-cache'  -u admin:nutanix/4u | jq -r .entities[].name


Echo ——————————————————
Echo Storage Containers
Echo ——————————————————

curl -s --insecure -X GET   https://10.68.69.102:9440/PrismGateway/services/rest/v2.0/storage_containers/   -H 'cache-control: no-cache'  -u admin:nutanix/4u | jq -r .entities[].name 



Echo ——————————————————
Echo IP Addresses
Echo ——————————————————

curl -s --insecure -X GET   'https://10.68.69.102:9440/PrismGateway/services/rest/v1/vms?count=50&page=1&sortCriteria=vm_name&searchAttributeList=vm_uuid&_=1495058816126&projection=stats%2CbasicInfo%2Calerts&filter='   -H 'cache-control: no-cache'  -u admin:nutanix/4u | jq -r .entities[].ipAddresses

