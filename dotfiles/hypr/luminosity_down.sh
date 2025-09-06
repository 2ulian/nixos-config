#!/bin/sh

v=$(ddcutil getvcp 10 | tr -d ' ' | cut -d '=' -f 2 | cut -d ',' -f 1)

v=$(($v-20))

echo $v

if [[ $v -lt 0 ]]
then
	v=0
	echo $v;
fi
ddcutil setvcp 10 $v --display 1 &
ddcutil setvcp 10 $v --display 2 &

exit 0
