#!/usr/bin/env bash
files=(/root/.mysql_history /var/log/lastlog /root/.bash_history /var/log/wtmp /var/log/auth.log /var/log/messages)

for file in ${files[*]}
do
    if [[ -f "$file" ]]
    then
        printf "\t%s\n" $file
        cat /dev/null > $file && history -c
    fi
done

rm -f /var/log/messages.*
rm -f /var/log/*.gz

if [ -f /etc/debian_version ]
then
    DEBIAN_FRONTEND=noninteractive
    apt-get autoremove -y
    apt-get clean -y
fi

history -c
unset HISTFILE
