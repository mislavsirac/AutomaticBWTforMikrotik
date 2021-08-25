#!/bin/bash

# USERNAME="user"
# PASSWORD="pw"

USERNAME=$1
PASSWORD=$2

rm cookie &> /dev/null

# echo '=================== STEP 1 ================='
s1=$(curl --location --request GET 'URL' -b cookie -c cookie -s)
#echo $s1

# echo '================== authState ==============='
authState=$(echo $s1 | cut -d '"' -f 132)
#echo $authState

# echo '=================== STEP 2 ================='
s2=$(curl --location --request POST 'URL' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "username=$USERNAME" --data-urlencode "password=$PASSWORD" --data-urlencode "AuthState=$authState" -c cookie -b cookie -s)
# echo $s2

# echo '================ SAMLResponse =============='
SAMLResponse=$(echo $s2 | cut -d '"' -f 36)
# echo $SAMLResponse

# echo '=================== STEP 3 ================='
s3=$(curl --location --request POST 'URL' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'RelayState=URL' --data-urlencode "SAMLResponse=$SAMLResponse" -c cookie -b cookie -s)
# echo $s3

PHPSESSID=$(cat cookie | grep 'PHPSESSID' | cut -d$'\t' -f 7)
#echo $PHPSESSID

SimpleSAMLAuthToken=$(cat cookie | grep 'SimpleSAMLAuthToken' | cut -d$'\t' -f 7)
#echo $SimpleSAMLAuthToken

echo "$PHPSESSID $SimpleSAMLAuthToken"

rm cookie
