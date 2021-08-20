#!/bin/bash
# Program:
#       For ClamAV SCAN use only
# History:
# 2021/08/17	KenieLiu	First release

# Update APT and install necessary package
apt-get update -y
apt-get install clamav clamav-daemon -y

# Check ClamAV version
clamscan --version

# Manual Update ClamAV database
service clamav-freshclam stop
freshclam
service clamav-freshclam start

# ClamAV scan all files in folder scan_file
result=$(clamscan -i -v -r scan_file)
echo "Scan is completed"
echo $result
if echo $result | grep -q "Infected files: 0";then
    echo "PASSED!!"
    echo "1" > result_clamav.txt
else
    echo "FAILED!!"
    echo "0" > result_clamav.txt
fi
