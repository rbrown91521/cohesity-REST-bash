#!/usr/bin/bash
################################################################################
# Script Name - auth3.sh
# Purpose - Generate Token from User Supplied Input
# Author - Russell Brown
# Contact Email: rbrown@cohesity.com
# Contact Phone: +1 747.241.7117
# Last Modified Date: 19 October 2022
# Tested against: 6.6.0d_u4_release-20220608_0753663c
################################################################################
# There's probably an easier way to do this but... this method works for me
################################################################################
tokenfileout="GetToken.sh"
# BEGIN function for user input
promptuserinput(){
  #Read Input from User Prompts
  #Cluster FQDN Name
  #iris_cli username
  #iris_cli password
echo "Please enter the Cluster FQDN>"
read clustername
# Write out the clustername for use with other scripts
echo $clustername>clusterFQDN.txt
echo "Please enter the iris_cli USERNAME for $clustername>"
read irisuser
echo "Please enter the PASSWORD for the user $irisuser>"
read -s irispasswd
}
# END function for user input
################################################################################
# CALL function for user input
promptuserinput
################################################################################
# BEGIN function for REST API Call
# The REST API Command will be a single line of input
# REST API Parameters are documented at developer.cohesity.com
callrest(){
commandbase="curl -X POST -k"
buildurl=" --url 'https://$clustername/irisservices/api/v1/public/accessTokens'"
switch1=" -H 'Accept: application/json'"
switch2=" -H 'Content-type: application/json'"
datavar1='"password": "'$irispasswd'"'
datavar2='"username": "'$irisuser'"'
datafull=" --data '{$datavar1, $datavar2}'\n"
fullcommand=$commandbase$buildurl$switch1$switch2$datafull
}
# END function for REST API Call 
################################################################################
# CALL REST API Call
callrest
# WRITE REST API Command to file
printf "$fullcommand">$tokenfileout
chmod 775 $tokenfileout
################################################################################
# EXECUTE REST API Command from file
./$tokenfileout>authreply.txt
################################################################################
# CONVERT output to json file
# You might have to change the next line to reflect python3
/usr/bin/python -m json.tool authreply.txt >auth.json
################################################################################
# ISOLATE Token from .json file
grep accessToken ./auth.json >token.txt
################################################################################
# TRIM Token out of variable
cat ./token.txt | cut -c 21- >token2.txt
authtoken=$(<token2.txt)
authtoken=${authtoken%??}
################################################################################
# EXPORT Token
printf "$authtoken">token.txt
################################################################################
# CLEANUP Files
rm ./auth.json
rm ./authreply.txt
rm ./GetToken.sh
rm ./token2.txt
################################################################################
# RESULTANT Output Files
# clusterFQDN.txt - for use with other REST API Scripts
# token.txt - for use with other REST API Scripts
# The token should be valid for 24 hours
printf "\nYour token is located at token.txt and will expire after 24 hours\n\n"
