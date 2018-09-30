**说明**: 因为在我试验中使用了zabbix-proxy,而我在监控rabbitmq相关数据时，通过zabbix-proxy获取时，始终提示rabbitmq的home未设置，而我是通过rpm包安装的rabbitmq,尝试找了几个认为正确的home，都无法正常获取数据。因而采用了下面的方法：在rabbitmq服务器通过脚本获得数据存入文件，zabbix-proxy去读取文件获取数据，在zabbix上进行展示。

* 1、rabbitmq服务器上脚本采集数据，并将数据存入rabbitmq服务器。
```
#!/bin/bash
while true
do
rabbitmqctl list_users |awk 'NR==2{print $1}' >/tmp/rabbitmq1.txt
rabbitmqctl list_queues |grep pallet-data-point-queue |awk '{print $2}' >/tmp/rabbitmq2.txt
rabbitmqctl list_queues |grep pallet-online-status-queue |awk '{print $2}' >/tmp/rabbitmq3.txt
rabbitmqctl list_queues |grep pallet_storage_change_queue |awk '{print $2}' >/tmp/rabbitmq4.txt
rabbitmqctl list_queues |grep relieving-then-pallet-message-alarm |awk '{print $2}' >/tmp/rabbitmq5.txt
sleep 300
done

```
