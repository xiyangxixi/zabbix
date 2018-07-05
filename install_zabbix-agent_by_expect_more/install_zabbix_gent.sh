#! /bin/bash

#rm -rf /root/.ssh/known_hosts
for i in {1..5}
do
 host=`sed -n "${i}p" /data/ip_list.txt |awk -F ":" '{print $1}'`
 passwd=`sed -n "${i}p" /data/ip_list.txt |awk -F ":" '{print $2}'`
  expect << EOF
  set timeout 300
  spawn ssh root@$host
  expect "yes/no" { send "yes\r" }
  expect "password" { send "${passwd}\r" }
  expect "#" { send "groupadd zabbix\r" }
  expect "#" { send "useradd -g zabbix zabbix -s /sbin/nologin\r" }
  expect "#" { send "mkdir /usr/local/zabbix\r" }
  expect "#" { send "scp 192.168.29.252:/data/zabbix_agents_3.2.0.linux2_6.amd64.tar.gz /usr/local/zabbix\r" }
  expect "yes/no" { send "yes\r" }
  expect "password" { send "123456\r" }
  expect "#" { send  "cd /usr/local/zabbix\r" }
  expect "#" { send "tar xf zabbix_agents_3.2.0.linux2_6.amd64.tar.gz\r" }
  expect "#" { send "sed -i '91c Server=192.168.29.251' /usr/local/zabbix/conf/zabbix_agentd.conf\r" }
  expect "#" { send "sed -ri \"/^Hostname/s/.*/Hostname=\\\${HOSTNAME%%.*}/\" /usr/local/zabbix/conf/zabbix_agentd.conf\r" }
  expect "#" { send "/usr/local/zabbix/sbin/zabbix_agentd -c /usr/local/zabbix/conf/zabbix_agentd.conf\r" }
  expect "#" { send "chmod -R 755 /usr/local/zabbix\r" }
  expect "#" { send "chown -R zabbix. /usr/local/zabbix\r" }
  expect "#" { send "rm -rf /usr/local/zabbix/zabbix_agents_3.2.0.linux2_6.amd64.tar.gz\r" }
  expect "#" { send "echo \"/usr/local/zabbix/sbin/zabbix_agentd -c /usr/local/zabbix/conf/zabbix_agentd.conf\" >> /etc/rc.local\r" }
  expect "#" { send "exit\r" }
EOF
done
