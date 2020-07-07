#!/bin/bash

number_of_monitors=`xrandr | grep " connected" -o | wc -w`

if [ $number_of_monitors == "2" ]
then
	xrandr --output eDP-1 --off
fi
