#!/bin/bash
[ $# -ne 2 ] && exit 1
jstack $1 >/tmp/jstack.log
top -H -p $1 -b -n1 | grep PID -A$2 | grep -v PID | awk '{print$1,$9}' >/tmp/topH.log
cat /tmp/topH.log | while read tid cpu;do
  xtid=`printf "%x\n" $tid`
  echo -e "\033[31m========================$xtid $cpu%\033[0m"
  cat /tmp/jstack.log | sed -n -e "/0x$xtid/,/^$/ p"
done
