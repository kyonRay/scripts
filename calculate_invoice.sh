#!/bin/bash
# get all filename in specified path

path=$1
nums=$(ls $path | grep pdf | sed -e 's/.pdf//g')
sum=0
for num in $nums
do
   sum=$(echo "$sum+$num"|bc)
done
echo $sum