#!/bin/bash
#批量爬取表情包
PIC_DIR="/tmp/emoji"
URL="https://fabiaoqing.com/search/search/keyword/"
INDEX="https://fabiaoqing.com/bqb/index.html"
BROWSER="Mozil5.0 (Windows NT 6.1; WOW64; rv:32.0) Gecko/20100101 Firefox/32.0"
EMJ_FILE="/tmp/list.conf"

[ -d $PIC_DIR ] || mkdir $PIC_DIR
[ -f $EMJ_FILE ] && rm -f $EMJ_FILE

curl -s ${INDEX}|grep -Eo "title.*表情包搜索"|tr -d [a-z=\"]|sed 's#表情包搜索##g;/^$/d' > $EMJ_FILE & 

for i in `seq -w 5 -1 0`
do
    echo -en "Please wait \e[0;31m$i\e[0m second...\r"
    sleep 1
done

if [[ ! -s $EMJ_FILE ]]; then
    echo -e "\033[31mNetwork problems, please reexecute the script\033[0m"
    exit 1
fi

cat << EOF
Emoji List: 
`cat $EMJ_FILE|xargs -n4|column -t`
EOF

echo
read -p "Please enter the label name of the download: " TAG

if [[ `grep "$TAG" $EMJ_FILE|wc -l` -ne 1 ]]; then
    echo -e "\033[31mThe label you entered is wrong\033[0m"
    exit 2
fi

read -p "Please enter the number of pages to download: " NUM

expr 1 + $NUM >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo -e "\033[31mYou entered the wrong number\033[0m"
    exit 3
fi

mkdir -p $PIC_DIR/$TAG
cd $PIC_DIR/$TAG
echo -e "\033[32mDownloading data...\033[0m"

START=`date +%s`
for i in {1..$NUM}.html
do
    curl --connect-timeout 2 -A $BROWSER -s $URL/$TAG/type/bq/page/$i|grep -Eo "http.*(jpg|gif)"|grep -v "title"|sed 's#^.*$#wget -q & #g'|bash 
    rm -f *jpg.*
    rm -f *gif.*
    tar zcf ${TAG}.tar.gz ./*
done

echo 'Total download time:' "$((`date +%s`-START))s"
