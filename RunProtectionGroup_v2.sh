#!/usr/bin/bash
################################################################################
# Script Name - RunProtectionGroup_v2 
# Purpose - Run Protection Group using REST_API v2
# Author - Russell Brown
# Contact Email: rbrown@cohesity.com
# Contact Phone: +1 747.241.7117
# Creation Date: 19 October 2022
# Tested against: 6.6.0d_u4_release-20220608_0753663c
################################################################################
# You will need to run the auth3.sh script to generate your Bearer Token
# auth3.sh will create the clusterFQDN.txt and token.txt files
# Those two files will be used by this script
clusterFQDN=$(<clusterFQDN.txt)
authtoken=$(<token.txt)
iofilehandle=runprotectiongroup
# The Protection Group ID should be in the form ClusterID:IncarnationID:JobID
# runType can be changed per the Cohesity REST_API Documentation located @
# developer.cohesity.com
curl -X POST -k \
  --url 'https://'$clusterFQDN'/v2/data-protect/protection-groups/8457538079309662:1660730777189:91/runs' \
  -H 'Authorization: Bearer '$authtoken \
  -H 'Accept: application/json'\
  -H 'Content-type: application/json' \
  --data '{
  "runType": "kRegular"
}' \
>$iofilehandle'.txt'
################################################################################
# CONVERT output to json file
# depending where you're runnning this script from
# the next line might need to reflect python3
/usr/bin/python -m json.tool $iofilehandle'.txt' >$iofilehandle'.json'
################################################################################
# CLEANUP Files
rm ./$iofilehandle'.txt'
################################################################################
# RESULTANT Output Files
# iofilehandle.json
