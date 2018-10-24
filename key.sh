#!/bin/bash
#批量分发密钥
IP=(
10.0.0.7
10.0.0.8
10.0.0.12
)
yum -y install sshpass >/dev/null 2>&1 || exit 1
rm -f /root/.ssh/id_rsa* 
ssh-keygen -t rsa -f /root/.ssh/id_rsa -P "" >/dev/null 2>&1

for ip in `echo ${IP[@]}`
do
    sshpass -p123456 ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$ip >/dev/null 2>&1
    if [[ $? -ne 0 ]];then
            echo -e "\033[31m$ip\tFailure\033[0m"
        else
            echo -e "\033[32m$ip\tSuccessful\033[0m"
    fi
done
