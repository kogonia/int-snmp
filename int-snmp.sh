#!/bin/bash

me=`basename "$0"`
i=0
args=($@)
for foo in ${args[@]}
do
    i=$(($i+1))
    case "$foo" in
        "-c"|"--community")
        community=${args[$(($i))]}
        ;;
        "-ip")
        ip=${args[$(($i))]}
        ;;
        "-h"|"--help")
        echo -e " -c|--community*community of your device (Default cisco);\n -ip*host ip address.\nFor example: $me -c cisco -ip 192.168.0.100\n"|column -t -s "*"
        exit 0
        ;;
    esac
done

[ -z "$ip" ] && 
printf "No host specified.\nUse $me -c 'community' -ip 'host ip address'\n" &&
exit 1
[ -z "$community" ] &&
printf "No community specified.\nDefault will be used: $me -c cisco -ip $ip\n" &&
community=cisco


sysName=$(snmpwalk -v 2c -c $community $ip 1.3.6.1.2.1.1.5 | awk -F ':' '{print $3 " " $4}'| awk '{print $1 "->" $4}')
sysDescr=$(snmpwalk -v 2c -c $community $ip 1.3.6.1.2.1.1.1)

ifDescr=$(snmpwalk -v 2c -c $community $ip 1.3.6.1.2.1.2.2.1.2 | cut -d' ' -f4 | tr '\n' ',')
arrDescr=()
IFS=',' read -r -a arrDescr <<< "$ifDescr"

ifAdminStatus=$(snmpwalk -v 2c -c $community $ip 1.3.6.1.2.1.2.2.1.7 | cut -d' ' -f4 | tr '\n' ',')
arrAdminStatus=()
IFS=',' read -r -a arrAdminStatus <<< "$ifAdminStatus"

ifAlias=$(snmpwalk -v 2c -c $community $ip 1.3.6.1.2.1.31.1.1.1.18 | cut -d' ' -f4 | tr '\n' ',')
arrAlias=()
IFS=',' read -r -a arrAlias <<< "$ifAlias"

arr=()
len=${#arrAlias[@]}
for (( c=0; c<$len; c++ ));
do
    arr+=( ${arrDescr[$c]} ${arrAdminStatus[$c]} ${arrAlias[$c]}\\n)
done
printf '=%.0s' {1..30}
echo -e "\n= $sysName"
echo -e "\nsysDescr:\n$sysDescr"|fold -w 70
printf '=%.0s' {1..30}
echo -e "\n"
echo -e "${arr[@]}"|column -t
