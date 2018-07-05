#! /bin/bash
/usr/local/mysql/bin/mysql -uroot -p123456 -e "create database zabbix character set utf8;"
/usr/local/mysql/bin/mysql -uroot -p123456 -e "create user zabbix@'%' identified by '123456';"
/usr/local/mysql/bin/mysql -uroot -p123456 -e "grant all privileges on zabbix.* to zabbix@'%';flush privileges;"
