#!/bin/bash

###################################################################################
#  author:leung                                                                   
#  date:2014.07.19                                                                 
#  需要先修改脚本中的音乐目录路径, music_dir='xxxx' 
#  用法:                                                                         
#  顺序播放: ./myplay.sh                                                     
#  随机播放: ./myplay.sh r                                                     
#  播某一首: ./myplay.sh song_file [times]                                  
###################################################################################

set -e

# modify here 
music_dir='some-collect'

random_play()
{
    echo "starting random play"
    ls $music_dir/* > tmp_filelist
    file_sum=$(wc -l tmp_filelist | awk '{print $1}')
    while :
    do
    random_num=$(($RANDOM%$file_sum))
    if [ $random_num -eq 0 ]; then
        continue
    fi
    music_play=$(cat tmp_filelist | sed -n $random_num'p')
    mplayer $music_play
done
}

sequence_play()
{
    echo "starting sequence play"
    for i in $(ls $music_dir/*);do
        mplayer $i
    done
}

if [ $1 ] && [ $1 == 'r' ]; then
    random_play
fi

if [ $1 ] && [ $2 ]; then
    echo "starting play $1 $2 times"
    seq $2 | xargs -i mplayer $1
elif [ $1 ] && [ ! $2 ]; then
    echo "starting play $1 one times"
    mplayer $1
elif [ ! $1 ]; then
    sequence_play
fi

exit 0;

