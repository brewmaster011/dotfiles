#!/bin/sh

#echo $(( $(brightnessctl g) * 10))%
printf "  %s" $(( $(brightnessctl g) * 10 ))%
