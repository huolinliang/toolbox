# some bash tools

These bash scripts are builded during my work, hope them can do some help.

* addr2line.sh  利用addr2line工具，从so库的报错信息中，找出对应在android源码中的错误位置 
* input\_simulate.sh  使用电脑键盘对android系统中进行简单的操作 
* myplay.sh  linux终端中调用mplayer播放音乐 
* build\_4k\_files.sh 自动创建4k大小的小文件 
* dd\_test.sh 测试flash读写可靠性 
* android\_build-rockchip\_based/mkvendor.sh 把定制apk存放在特定vendor分区中，此脚本需要配合mkimage.sh打包脚本 
* android\_build-rockchip\_based/mkimage.sh 打包脚本 
* android\_build-rockchip\_based/add\_product.sh 自动生成新的产品目录 
* android\_build-rockchip\_based/build\_android.sh  android编译脚本
* android\_build-rockchip\_based/build\_kernel.sh  内核编译脚本
* add\_remote\_for\_all.sh  为某个repo下的所有git仓库添加自己的remote地址
* markdown2html/md2html.sh Markdown转html工具
* checkcert.sh 查看apk签名工具
* find\_active\_ip.sh 扫描某网段内的活跃ip

## clone the repository.

    $ git clone https://github.com/huolinliang/toolbox.git
