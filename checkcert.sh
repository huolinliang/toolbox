#!/bin/bash 
###################################################################
# version:v0.1
# modified by:leung
# 该脚本的作用是查看apk的签名，使用方法 ./checkcert.sh your.apk
# 支持一次查看多个apk， ./checkcert 1.apk 2.apk
###################################################################

#set -e

usage () {
    echo -e "\nError: You should run it like this--->  ./checkcert.sh your.apk\n"
}

if [ $# -eq 0 ]; then
    usage
fi

mkdir .temp 
cd .temp
apk_count=0 
while [ $1 ];
do 
    apk_count=$(($apk_count + 1)) 
    echo -e "\n($apk_count) $1:\n" 
    cert_path=$(jar -tf ../$1 | grep -iI "RSA")
    if [ $? -ne 0 ]; then
        echo -e "\nFailed to check \"$1\""
        echo -e "Is that an apk?\n"
        shift 
        continue
    fi
    jar -xf ../$1 $cert_path 
    keytool -printcert -file $cert_path 
    rm -r $cert_path 
    echo ""
    shift 
done 
cd ../
rm -r .temp
exit 0
