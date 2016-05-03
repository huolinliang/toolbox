#/bin/bash

################################################################
# version:v0.1
# modified by:leung
# 直接运行该脚本，可以扫描当前某一网段下活跃的ip地址
################################################################

set -e
# modify here
net_segment=192.168.11

count=0
while [ $count -lt 255 ];
do
    count=$(($count + 1))
    active_ip=$(ping -c 1 $net_segment.$count | grep -i "icmp_seq" | awk '{print $4}'| sed 's/://g')
    echo $active_ip
done
exit 0

