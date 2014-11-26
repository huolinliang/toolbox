#!/bin/sh
######################################################################################
# version:v0.1
# 该脚本的作用是利用dd命令，对android平板或者盒子进行flash可靠性测试。
# 使用该脚本，需要提前往android设备中刷入自己制做的根文件系统，把常用的linux命令包含进去
# 该脚本可以扫描flash中的所有分区，并按一定的字节大小进行写操作，然后再进行读操作，
# 直至整个flash都读写一遍。如果中途出现写失败，读失败，或者读出来的数据与写的有差异，
# 即判断为failed,最后统计failed的计数。
# 默认对整个flash读写50次
# 根文件系统，即rootfs.img的制作，可见http://makerootfs.sourceforge.net/
######################################################################################

ulimit -n 1024000
read_failed_count=0
write_failed_count=0
differ_count=0
total=50

read_failed () {
    echo "[Read Failed] $@"
    read_failed_count=$(($read_failed_count+1))
}

write_failed () {
    echo "[Write Failed] $@"
    write_failed_count=$(($write_failed_count+1))
}

differ () {
    echo "[Differ] $@"
    differ_count=$(($differ_count+1))
}

summary () {
    echo "## summary ##"
    echo "total: $total"
    echo "read failed: $read_failed_count"
    echo "write failed: $write_failed_count"
    echo "differ: $differ_count"
}

count=1
while [ $count -le $total ]; do

    for mtd_dev in $(cat /proc/mtd | awk -F ":" '/mtd/ { print $1 }'); do

        info_path="/sys/devices/virtual/mtd/${mtd_dev}"
        dev_path="/dev/${mtd_dev}"

        name=$(cat "${info_path}/name")
        size=$(($(cat "${info_path}/size")))
        erasesize=$(($(cat "${info_path}/erasesize")))

        echo "$mtd_dev"
        num=256
        dd if=/dev/urandom of=/tmp/idat bs=$erasesize count=$num 1>/dev/null 2>&1

        for i in $(seq 0 $(($size/($erasesize*$num)-1))); do
            dd if=/tmp/idat of=$dev_path bs=$erasesize count=$num seek=$i 1>/dev/null 2>&1 || write_failed "$count $name $i"
            sync
            dd if=$dev_path of=/tmp/odat bs=$erasesize count=$num skip=$i 1>/dev/null 2>&1 || read_failed "$count $name $i"
            sync
            diff /tmp/idat /tmp/odat 1>/dev/null 2>&1 || differ "differ: $count $name $i"
        done

    done

    count=$(($count+1))
	echo "count num:$count"

done

summary

