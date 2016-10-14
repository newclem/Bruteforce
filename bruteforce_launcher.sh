#!/bin/bash

#Premier argument dump de smart_hashdump

if [[ $(id -u) -ne 0 ]];
then 
    printf "Please run the script as root"
    exit 1;
fi

printf "[*] Backuping old pots and removing old backup\n"
rm -f /opt/john/run/john.pot.bak
mv /opt/john/run/john.pot /opt/john/run/john.pot.bak

rm -f /opt/hashcat/hashcat.pot.bak
mv /opt/hashcat/hashcat.pot /opt/hashcat/hashcat.pot.bak

printf "[*] Launcher brute force\n" 

printf "[*] John The Ripper\n" 
printf "[*] Single mode\n"
/opt/john/run/john --single --format=NT --fork=8 "$1"

cat "$1" | cut -d":" -f4 > /tmp/hashes

printf "[*] Hashcat\n"
printf "[*] Dictionnary attack\n"
printf "[*] Creating dictionnary\n"
/home/pentest/Documents/scripts/create_dictionnary.sh

printf "[*] Starting attack\n"
/opt/hashcat/hashcat64.bin -m 1000 /tmp/hashes /home/pentest/Documents/dictionnaire/dico.txt

printf "[*] No brain mode\n"
/opt/hashcat/hashcat64.bin -m 1000 -a 3 -1 '?l?d?u*$%&@-_??!.' --increment --increment-min 6 /tmp/hashes "?1?1?1?1?1?1?1?1?1?1?1?1"

printf "[*] END\n"
