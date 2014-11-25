#!/bin/bash

############################################################################################################
# version:v0.1
# author:leung
# 该脚本的目的是希望利用addr2line工具，从so库的报错信息中，找出对应在源码中的错误位置
# 该脚本应当运行在android的根目录，并且预先执行source xxx和lunch xxx命令
# 把报错信息按一定格式保存到一个文件中，然后在执行该脚本时作为参数传进去运行，如./addr2line.sh log.tmp
# 错误信息的文本格式请参考log.tmp文件
#
# 该脚本的期望只是半自动使用addr2line工具，有啥疑难杂症，请回归手动,useage参考如下：
# ./prebuilts/tools/gcc-sdk/addr2line -e xxx.so 0011baba
############################################################################################################

set -e

if [ ! $1 ]; then
    echo "you should run this like './addr2line.sh xxxx'"
    exit -1
else
    filename="$1"
fi

if [ ! $OUT ]; then
    echo "you should source and lunch a product first!"
    exit -1
fi

line_num=$(cat $filename | wc -l)
addr_length=8    #默认地址为64位，例如00b2c931
output_file="$filename.out"

cp $filename $filename.out
echo -e "\n" >> $output_file

count=1
tc1=$(date +%s)
while [ $count -le $line_num ];
do
    each_line=$(cat $filename | sed -n $count'p')      #统计行数
    position=$(($(expr index "$each_line" "pc")+3))    #确定报错内存地址信息在字符串中的位置,以pc作为关键字
    addr_data=$(expr substr "$each_line" $position $addr_length)  #提取子字符串并保存
    check_so=${each_line:$(($position+10))}     #提取so库的路径信息
    check_so=$OUT/symbols/$check_so             #对路径信息补全,使用完整的绝对路径
    if [ ! -f $check_so ]; then
        echo "$check_so not found" >> $output_file
        count=$(($count+1))
        continue
    fi
    ./prebuilts/tools/gcc-sdk/addr2line -e $check_so $addr_data >> $output_file    #利用addr2line工具分析
    count=$(($count+1))
done
tc2=$(date +%s)
echo -e "\n\t done.\n\t it takes $(($tc2 - $tc1)) seconds."
echo -e "\t output file: $output_file\n"

exit 0

