#!/bin/bash

######################################################################
# version:v0.1
# author:leung
# 以4k的大小新建一定数量的文件，可用于测试flash小文件拷贝速度
# 默认是新建1w个文件，可修改max_file_num增加或减少
######################################################################

set -e

if [ -d ./4k-files ]; then
rm -rf ./4k-files/*
else
mkdir ./4k-files
fi

file_count=1
max_file_num=10000

while [ $file_count -le $max_file_num ]; do
    dd if=/dev/urandom of=./4k-files/$file_count bs=4k count=1 1>/dev/null 2>&1
    #dd if=/dev/urandom of=./4k-files/$file_count bs=4k count=1 &>/dev/null
    file_count=$(($file_count+1))
done

exit 0;
