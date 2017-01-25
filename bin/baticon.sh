#!/bin/zsh
upow="`upower -d`"
echo $upow | grep on-battery: | grep no && {
		#On AC
		echo "On AC"
		icon_name=`echo $upow | grep icon-name| egrep -o "'.*'" |
		grep ac`
	} || {
		#On battery
		echo "On battery"
		icon_name=`echo $upow | grep icon-name| egrep -o "'.*'" |
	   	grep bat | head -1`
}
echo ICON:
echo $icon_name
