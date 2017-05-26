#!/bin/bash 

read -p 'Please Enter your Name: ' User
echo Hello $User.  I hear you want to create a container and optionally enable compression
read -p 'Enter your desired container name: ' Name
read -p 'Compression Enabled (TRUE or FALSE): ' Compression



#Create A Container
curl --insecure -X POST \
  https://10.68.69.102:9440/PrismGateway/services/rest/v2.0/storage_containers/ \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -u admin:nutanix/4u \
  -d "{  
   \"id\":null,
   \"name\":\"$Name\",
   \"storagePoolId\":\"00054f6b-7dc6-c1ce-2a69-001fc69c6e48::3\",
   \"totalExplicitReservedCapacity\":0,
   \"advertisedCapacity\":null,
   \"compressionEnabled\":\"$Compression\",
   \"compressionDelayInSecs\":0,
   \"fingerPrintOnWrite\":\"OFF\",
   \"onDiskDedup\":\"OFF\"
}"