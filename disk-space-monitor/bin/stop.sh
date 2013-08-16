#!/usr/bin/env bash
pid=`ps gaux | grep disk-check.sh | grep -v grep | awk '{print $2}'`
echo "The disk-check.sh process pid is $pid ."
kill -9 $pid
echo "Stop the process of pid $pid ."
