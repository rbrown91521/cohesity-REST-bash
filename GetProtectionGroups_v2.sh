#!/usr/bin/bash
################################################################################
# Script Name - GetProtectionGroups_v2.sh
# Purpose - Get Protection Groups REST_API v2
# Author - Russell Brown
# Contact Email: rbrown@cohesity.com
# Contact Phone: +1 747.241.7117
# Creation Date: 19 October 2022
# Tested against: 6.6.0d_u4_release-20220608_0753663c
################################################################################
# You will need to run the auth3.sh script to generate your Bearer Token
# auth3.sh will create the clusterFQDN.txt and token.txt files
# Those two files will be used by this script
iofilehandle=protectiongroups
clusterFQDN=$(<clusterFQDN.txt)
authtoken=$(<token.txt)
curl -X GET -G -k \
  --url 'https://'$clusterFQDN'/v2/data-protect/protection-groups' \
  -H 'Authorization: Bearer '$authtoken \
  -H 'Accept: application/json' \
  -H 'requestInitiatorType: UIUser' \
>$iofilehandle'.txt'
################################################################################
# CONVERT output to json file
# Depending on your system, you might need to change the next line to python3
/usr/bin/python -m json.tool $iofilehandle'.txt' >$iofilehandle'.json'
################################################################################
# CLEANUP Files
rm ./$iofilehandle'.txt'
################################################################################
# RESULTANT Output Files
# iofilehandle.json
