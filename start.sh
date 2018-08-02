#!/bin/sh
echo "hello      17777/tcp" >> /etc/services
/etc/init.d/xinetd restart
/etc/init.d/ssh restart
/etc/init.d/cron restart
/bin/bash
sleep infinity
