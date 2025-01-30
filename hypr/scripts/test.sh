#!/bin/bash


read -r line

case $line in
    o1*) echo $line ;;
    o2*) echo 2 ;;
    *) echo 3 ;;
esac
