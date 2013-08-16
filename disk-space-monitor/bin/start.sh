#!/usr/bin/env bash
nohup sh /home/admin/diskUsageCheck/bin/disk-check.sh alarmType /home/admin/hadoop/image/current 527000 > /home/admin/hadoop/diskUsageCheck/log/diskUsage.log 2>&1 &
echo $! > /home/admin/diskUsageCheck/log/pid
echo "The disk-check.sh has started ..."
echo "It's pid is $! ."
