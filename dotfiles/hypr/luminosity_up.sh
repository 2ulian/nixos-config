#!/bin/sh

v=$(ddcutil getvcp 10 | tr -d ' ' | cut -d '=' -f 2 | cut -d ',' -f 1)

v=$(($v+20))

echo $v

if [[ $v -gt 100 ]]
then
	v=100
	echo $v;
fi
ddcutil setvcp 10 $v --display 1 &
ddcutil setvcp 10 $v --display 2 &

exit 0
