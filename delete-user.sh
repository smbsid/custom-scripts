#!/bin/bash
#Script to delete Linux users provided in a list given in argument
#Example: sudo bash delete-user.sh userslist.txt

filename=$1
n=1
echo "++ Suppression en cours des users..."

while read -r line;
do
userdel -f "$line"
n=$((n+1))
done < $filename

echo "++ Suppression terminée"
