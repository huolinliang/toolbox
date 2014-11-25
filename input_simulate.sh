#!/system/bin/sh
#######################################################################################
# version:v0.1
# author:leung
# 该脚本的目的是使用input指令，使用键盘在android系统中进行简单的操作。
# 把该脚本adb push到android设备中，添加可执行权限，然后在adb环境中执行即可。挺好玩的
# 
# h,j,k,l 是vim的操作风格，代表左上下右
# t 是take a picture，可以在摄像模式中拍照
# u 是unlock，可以让机器从锁屏状态中解锁
# m 是mute，表示静音
# d 是delete，表示删除字符
# p 是power，表示power键
# H 大写的H是home键
# b 是back，表示返回键
# T 是Tab键，可以切换按钮
# f 是focus，可以使camera对焦
# X 大写的X是表示enter键
# +,-,x,/ 表示加减乘除，乘号之所以用小写的x是因为*号是通配符
# i 是insert，是vim的操作风格，输入i之后就进入输入模式
#
# #####################################################################################

set -e

count=1

insert()
{
    read insert
    input text $insert
}


while [ $count -le 1000 ]
do
    read -s -n1 input
    case $input in
        h)
            input keyevent 21;;
        j)
            input keyevent 20;;
        k)
            input keyevent 19;;
        l)
            input keyevent 22;;
        t)
            input keyevent 27;;
        u)
            input keyevent 82;;
        m)
            input keyevent 164;;
        d)
            input keyevent 67;;
        p)
            input keyevent 26;;
        H)
            input keyevent 3;;
        b)
            input keyevent 4;;
        T)
            input keyevent 61;;
        f)
            input keyevent 80;;
        X)
            input keyevent 66;;
        +)
            input keyevent 81;;
        -)
            input keyevent 69;;
        x)
            input keyevent 17;;
        /)
            input keyevent 76;;
        =)
            input keyevent 70;;
        i)
            insert;;
        *)
            exit -1
    esac
    count=$(($count+1))
done
