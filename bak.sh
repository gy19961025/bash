#!/bin/bash
#备份脚本
HOSTNAME=`hostname`
IP=`ifconfig eth1|awk 'NR==2{print $2}'`
DATE=`date +%F -d "-1days"`
DATA_DIR="/web-node1"
BAK_DIR="/backup/$HOSTNAME-$IP"

mkdir -p $BAK_DIR && \
cd $DATA_DIR && \
find ./ -type d|xargs tar zcf $BAK_DIR/${DATE}.tar.gz && \
#需提前在备份端/backup目录下创建以hostname-ip命名的目录
scp -p $BAK_DIR/${DATE}.tar.gz root@10.0.0.12:$BAK_DIR
