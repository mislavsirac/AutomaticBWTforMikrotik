#!/bin/bash

USERNAME="user"
PASSWORD="pw"

MIKROTIK_IP="IP"
MIKROTIK_USERNAME="user"
MIKROTIK_PASSWORD="pw"

ipArr=();
hostArr=();
speedArr=();
brzineArr=();
uGBrzina=();

rm input.txt &> /dev/null
rm hostnameovi.txt &> /dev/null

# ===========================================================================================================================
function rw(){
    sshpass -p $MIKROTIK_PASSWORD scp input.txt $MIKROTIK_USERNAME@$MIKROTIK_IP:"input.txt"
    sshpass -p $MIKROTIK_PASSWORD ssh -o StrictHostKeyChecking=no $MIKROTIK_USERNAME@$MIKROTIK_IP 'system script run BWtest';
    sshpass -p $MIKROTIK_PASSWORD scp $MIKROTIK_USERNAME@$MIKROTIK_IP:"rez.txt" rez.txt

    echo "INPUT:"
    cat input.txt
    echo "OUTPUT:"
    wc -l rez.txt
    cat rez.txt

    while read line; do
        denis=$(echo $line | awk -F "\"*,\"*" '{print $1}')
        tenis=$(echo $line | awk -F "\"*,\"*" '{print $2}')
        if echo $denis $tenis | awk '{exit !( $1 == 0 && $2 == 0 )}'; then
                speedArr+=("/")
        elif echo $denis $tenis | awk '{exit !( ($1 - $2) > 25.0)}'; then
                speedArr+=("$denis/$tenis Mbps")
        elif echo $denis $tenis | awk '{exit !( ($1 - $2) < -25.0)}'; then
                speedArr+=("$denis/$tenis Mbps")
        else
                speedArr+=("$(echo $denis $tenis | awk '{print ($1 + $2)/2}') Mbps")
        fi
    done < rez.txt

    echo ${#speedArr[@]}
    echo ${speedArr[*]}
    i=0;
    rm input.txt &> /dev/null
}



# ===========================================================================================================================
while read line; do
    ip=$(echo $line | cut -d ':' -f1);
    host=$(echo $line | cut -d ':' -f4);
    ipArr+=($ip);
    hostArr+=($host);

done < router-asd.db
# ===========================================================================================================================
i=0;
for value in "${ipArr[@]}"
do
    i=$(($i+1));
    echo $value >> input.txt
    if [ $i == 200 ]; then
        rw
        i=0;
    fi
done

if [ $i != 0 ]; then
    rw
fi

# ===========================================================================================================================
loginData=$(./login.sh $USERNAME $PASSWORD)
PHPSESSID=$(echo $loginData | cut -d ' ' -f1)
SimpleSAMLAuthToken=$(echo $loginData | cut -d ' ' -f2)

for value in "${hostArr[@]}"
do
    echo $value

    # brzina=$(curl "LINK?onthefly=${value::-1}" -s -u "$USERNAME:$PASSWORD" | html2text | grep brzina | cut -d ' ' -f3,4 | sed 's/,//g' | xargs)
    # if [[ $brzina == "" ]]; then
    #     brzina="nea_nis"
    # fi
    # echo $brzina
    # brzineArr+=($brzina)

    id=$(curl "LINK?onthefly=${value::-1}" -s -u "$USERNAME:$PASSWORD" | html2text | grep "ID" | cut -d ':' -f2)
    echo $id

    if [[ "$id" == "" ]]
    then
        echo "/"
        uGBrzina+=("/")
        continue
    fi

    uBrzina=$(curl -s -XGET -H "Cookie: PHPSESSID=$PHPSESSID; SimpleSAMLAuthToken=$SimpleSAMLAuthToken" "LINK?m=32&do=2&id=$id" | grep "b/s" | head -n1 | xargs)
    echo ${uBrzina::-7}
    uGBrzina+=("${uBrzina::-7}")

done

# ===========================================================================================================================
rm OUTPUT.txt &> /dev/null

echo "ipArr: ${#ipArr[@]}"
echo $ipArr
echo "hostArr: ${#hostArr[@]}"
echo $hostArr
echo "speedArr: ${#speedArr[@]}"
echo $speedArr
echo "uGBrzina: ${#uGBrzina[@]}"
echo $uGBrzina

for key in "${!ipArr[@]}"
do
    echo "${ipArr[$key]},${hostArr[$key]},${speedArr[$key]},${uGBrzina[$key]}" >> OUTPUT.txt
done
