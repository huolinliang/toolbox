#!/bin/bash

set -e

usage()
{
    echo "usage: $0 [apadh|apadl] [misc boot recovery system]"
    exit 1
}

make_misc()
{
    echo -n "create misc.img.... "
    cp -a rkst/Image/misc.img rockdev/Image/misc.img
    cp -a rkst/Image/pcba_small_misc.img rockdev/Image/pcba_small_misc.img
    cp -a rkst/Image/pcba_whole_misc.img rockdev/Image/pcba_whole_misc.img
    echo "done."
}

make_boot()
{
    echo -n "create boot.img without kernel... "
    if [ -d $OUT/root ]; then
        mkbootfs $OUT/root | minigzip > $OUT/ramdisk.img
        rkst/mkkrnlimg $OUT/ramdisk.img rockdev/Image/boot.img >/dev/null
    fi
    echo "done."
}

make_recovery()
{
    echo -n "create recovery.img with kernel... "
    if [ -d $OUT/recovery/root ]; then
        mkbootfs $OUT/recovery/root | minigzip > $OUT/ramdisk-recovery.img
        mkbootimg --kernel $OUT/kernel --ramdisk $OUT/ramdisk-recovery.img \
            --output $OUT/recovery.img
        cp -a $OUT/recovery.img rockdev/Image/
    fi
    echo "done."
}

get_fstype()
{
    partition="$1"
    fstype=$(grep -h "mtd@$partition" $OUT/root/init.rk30board.rc | head -n 1 | awk '{ print $2 }')
    [ -z "$fstype" ] && fstype="ext4"
    echo "$fstype"
}

make_ext4fs()
{
    DIR="$1"
    IMG="$2"
    label="$(basename $IMG ".img")"

    if [ ! -d $DIR ]; then
        echo "Cann't find $DIR"
        return 1
    fi

    delta=5120
    num_blocks=$(du -sk $DIR | awk '{print $1}')
    num_blocks=$(($num_blocks + $delta))
    num_inodes=$(find $DIR | wc -l)
    num_inodes=$(($num_inodes + 500))

    ok=0
    while [ "$ok" = "0" ]; do
        genext2fs -d $DIR -b $num_blocks -N $num_inodes -m 0 $IMG >/dev/null
        tune2fs -j -L $label -c -1 -i 0 $IMG >/dev/null 2>&1 && \
        ok=1 || num_blocks=$(($num_blocks + $delta))
    done
    e2fsck -fy $IMG >/dev/null 2>&1 || true

    delta=1024
    num_blocks=$(resize2fs -P $IMG 2>/dev/null | awk -F: '{print $2}')

    ok=0
    while [ "$ok" = "0" ]; do
        if [ "$label" == "system" ] || [ "$label" == "userdata" ]; then
            genext2fs -a -d $DIR -b $num_blocks -N $num_inodes -m 0 $IMG >/dev/null
        else
            genext2fs -d $DIR -b $num_blocks -N $num_inodes -m 0 $IMG >/dev/null
        fi
        tune2fs -O dir_index,filetype,sparse_super -j -L $label -c -1 -i 0 $IMG >/dev/null 2>&1 && \
        ok=1 || num_blocks=$(($num_blocks + $delta))
    done
    e2fsck -fyD $IMG >/dev/null 2>&1 || true
}

make_system()
{
    echo -n "creating system.img ... "
    fstype=$(get_fstype)
    if [ "$fstype" = "ext4" ] || [ "$fstype" = "ext3" ]; then
        make_ext4fs $OUT/system rockdev/Image/system.img
    fi
    echo "done"
}

make_userdata()
{
    echo -n "creating userdata.img ... "
    fstype=$(get_fstype)
    if [ "$fstype" = "ext4" ] || [ "$fstype" = "ext3" ]; then
        make_ext4fs $OUT/data rockdev/Image/userdata.img
    fi
    echo "done"
}

make_vendor()
{
	./device/rockchip/$TARGET_PRODUCT/vendor/mkvendor.sh
    echo -n "creating vendor.img ... "
    fstype=$(get_fstype)
    if [ "$fstype" = "ext4" ] || [ "$fstype" = "ext3" ]; then
        make_ext4fs $OUT/vendor rockdev/Image/vendor.img
    fi
    echo "done"
}


mkdir -p rockdev/Image

case $1 in
    apadh|apadl)
        source build/envsetup.sh >/dev/null
        setpaths
        lunch ${1}-eng >/dev/null
        shift
        ;;
esac

[ -z "$OUT" ] && usage

targets="misc boot recovery system"

if [ $# -gt 0 ]; then
    targets="$@"
fi

echo "building image [$targets] for $(basename $OUT)"

for target in $targets; do
    case $target in
        misc)
            make_misc
            ;;
        boot)
            make_boot
            ;;
        recovery)
            make_recovery
            ;;
        system)
            make_system
            ;;
        userdata)
            make_userdata
            ;;
        vendor)
            make_vendor
            ;;
        *)
            usage
            ;;
    esac
done
	
