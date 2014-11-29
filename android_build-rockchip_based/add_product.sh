#!/bin/bash
############################################################
# 该脚本用于在一套android工程中添加不同的新产品，
# 从而可以分离出一些定制的修改
# 如该脚本可以在android_source/device/samsung/下运行，
# 以某款产品，如meta为模板基础来生成新的产品目录
###########################################################
set -e

usage()
{
    echo "$0 parent_name product_name"
    exit -1
}

if [[ $# -ne 2 ]]; then
    usage
fi

parent_product=$(pwd)/$1
parent_name=$1

child_product=$(pwd)/$2
child_name=$2

if [[ ${child_name} = ${parent_name} || -d ${child_product} ]]; then
    usage
fi

cp -rf ${parent_product} ${child_product}

modify_files=$(find ${child_product} -name "*.mk")
modify_files+=" ${child_product}/vendorsetup.sh"

sed -i "/${parent_name}/s/${parent_name}/${child_name}/" ${modify_files}

mv ${child_product}/${parent_name}.mk ${child_product}/${child_name}.mk
