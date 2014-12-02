#!/bin/bash

#######################################################################
# version:v0.1
# author:leung
# 该脚本的作用是为repo下的所有git添加公司自己用的remote仓库地址
# 主要就是根据project.list中的仓库名字，自动循环执行
#######################################################################
set -e
project_list=".repo/project.list"
project_num=$(cat $project_list | wc -l)


count=1
while [ $count -le $project_num ];
do
	project_name=$(cat .repo/project.list | sed -n $count'p')
	repo forall $project_name -c git remote add your_remote git@192.168.1.111:rk3188_mid_4.4.2/$project_name'.git'
	count=$(($count+1))
done



#################################################
# 给所有的remote仓库添加projectname属性
#################################################

for file in `find ./*/.git -name config`
do
sed -n '/projectname/'p $file >> $file
done

for file in `find ./*/*/.git -name config`
do
sed -n '/projectname/'p $file >> $file
done

for file in `find ./*/*/*/.git -name config`
do
sed -n '/projectname/'p $file >> $file
done

for file in `find ./*/*/*/*/.git -name config`
do
sed -n '/projectname/'p $file >> $file
done

for file in `find ./*/*/*/*/*/.git -name config`
do
sed -n '/projectname/'p $file >> $file
done

for file in `find ./*/*/*/*/*/*/.git -name config`
do
sed -n '/projectname/'p $file >> $file
done


################################################################################
# 上述工作完成后，应该先抽查一下各个git配置文件，然后再推送到服务器上比较稳妥,
# 自动推送可参考下面的命令，注意修改一个远程服务器名称，和分支名称即可
# repo forall -c git push origin master/dev/xxx
################################################################################

