#!/bin/bash

#content-type
CT="Content-Type:application/json"

#User Creds
USER="admin"
PASSWD="nutanix/4u"

All_TASKS=$(curl -s --insecure  -u $USER:$PASSWD -X POST https://10.68.69.102:9440/PrismGateway/services/rest/v2.0/tasks/list -H 'cache-control: no-cache' -H 'content-type: application/json'  -d '{}')
ALL_Alerts=$(curl -s --insecure -u $USER:$PASSWD -X GET 'https://10.68.69.102:9440/PrismGateway/services/rest/v1/alerts/?resolved=false&acknowledged=false' -H 'cache-control: no-cache')

Cluster=$(curl -s --insecure -u $USER:$PASSWD -X GET https://10.68.69.102:9440/PrismGateway/services/rest/v2.0/cluster/ -H 'cache-control: no-cache')


#Total_Tasks=$( echo "$All_TASKS" | jq '-r .metadata.total_entities' )

#Total_Tasks=$( echo jq -r  '.metadata.count' <<< "${All_TASKS}" )

echo The cluster appears to be up and working. Here is some quick information that might help

echo Total Tasks on the system:
echo "$All_TASKS" | jq -r .metadata.total_entities
echo 
echo The following tasks ARE NOT complete:
echo "$All_TASKS" | jq  '.entities[] | select(.progress_status != "Succeeded") | .operation_type'
echo The following tasks ARE complete:
echo "$All_TASKS" | jq  '.entities[] | select(.progress_status == "Succeeded") | .operation_type'
#'.DATA[]  | select(.DOMAIN == "domain2") | .DOMAINID'


echo The following alerts have not been resolved or acknowledged
echo Total: 
echo "$ALL_Alerts" | jq -r .metadata.totalEntities
echo Here is a quick list of existing alerts in the system:
echo "$ALL_Alerts" | jq  '.entities[] | .alertTitle'

echo While not perfect, read through this for some more details on the cluster, health and stats:
echo "$Cluster" | jq  -r

#echo "${json}" | jq --arg subnet "$subnet" '.subnets[] | select(.cidr | startswith($subnet)).id'
