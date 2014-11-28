#!/bin/sh

set -e
VENDOR=device/rockchip/$TARGET_PRODUCT/vendor

######检查目录，先清空相关目录再复制，避免多余数据
if [ -d $OUT/vendor ];then
    rm -rf $OUT/vendor/*
else
    mkdir $OUT/vendor
fi

if [ -d $OUT/system/vendor ] && [ $(ls $OUT/system/vendor | wc -l) -gt 0 ]; then
    cp -r $OUT/system/vendor/* $OUT/vendor/
else
    echo -e "\n\t\033[31m Error: Please build android complete first \033[0m\n"
    exit -1
fi

if [ ! -d $VENDOR/app ]; then
    echo -e "\n\t\033[31m Error: Can not find dir-->$VENDOR/app \033[0m\n"
    exit -1
elif [ $(ls $VENDOR/app/*.apk | wc -l) -eq 0 ]; then
    echo -e "\n\t\033[31m Error: There's no apk in -->$VENDOR/app \033[0m\n"
    exit -1
else
    cp -r $VENDOR/* $OUT/vendor/
fi

if [ -d $OUT/vendor/lib ];then
    rm -rf $OUT/vendor/lib/*
else
    mkdir $OUT/vendor/lib
fi

if [ -d $OUT/system/vendor/lib ] && [ $(ls $OUT/system/vendor/lib | wc -l) -gt 0 ]; then
    cp -r $OUT/system/vendor/lib/* $OUT/vendor/lib/
fi

######解压apk并拷贝其中的so库文件
for i in $(ls $VENDOR/app/*.apk | awk '{print $1;}');do
    if [ -d $VENDOR/apk_tmp ];then
        rm -rf $VENDOR/apk_tmp/*
    else
        mkdir $VENDOR/apk_tmp
    fi
    unzip -q $i -d $VENDOR/apk_tmp/
    chmod -R 755 $VENDOR/apk_tmp
    find $VENDOR/apk_tmp/lib/armeabi-v7a -name "*.so" 2>/dev/null -exec cp -r {} $OUT/vendor/lib/ \; || \
        find $VENDOR/apk_tmp/lib/armeabi -name "*.so" 2>/dev/null -exec cp -r {} $OUT/vendor/lib/ \; || \
        find $VENDOR/apk_tmp/lib -name "*.so" 2>/dev/null -exec cp -r {} $OUT/vendor/lib/ \; || \
        echo "  Info: $i 该应用不包含so库文件"
    for j in $(ls -1 $OUT/vendor/lib/);do
        if [ -f $OUT/system/lib/$j ];then
            echo -e "\033[31m  Warning: $i 企图替换系统中的同名库文件:$j , 已阻止并将强制使用系统自带的库，如果此应用因此有问题，从vendor中删掉 \033[0m"
            rm $OUT/vendor/lib/$j
        fi
    done
done

rm -rf $VENDOR/apk_tmp
rm $OUT/vendor/mkvendor.sh

