#!/bin/bash

####################################################################
# version:v0.1
# author:leung
# 该脚本是用于将markdown文件转换成html文件
# 利用的是官方的转换工具Markdown.pl
# 后缀名为md或者markdown都是支持的
####################################################################

usage()
{
    echo "usage: $0 xxx.md ]"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi
filename=$1

if [ "${1##*.}" = "md" ]; then
    echo "Found a .md file"
    new_filename=${filename%.md}
elif [ "${1##*.}" = "markdown" ]; then
    echo "Found a .markdown file"
    new_filename=${filename%.markdown}
fi

Markdown.pl --html4tags $filename > ${new_filename}.html


