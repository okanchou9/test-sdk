#!/bin/bash
# Program:
#       For ClamAV and VirusTotal SCAN use only
# History:
# 2021/08/16	KenieLiu	First release
# 2021/08/17	KenieLiu    Add loop scan file function

# Update APT and install necessary package
apt-get update -y
apt-get install curl wget jq zip -y
#clamav clamav-daemon

## Check ClamAV version
#clamscan --version
#
## Manual Update ClamAV database
#service clamav-freshclam stop
#freshclam
#service clamav-freshclam start

# Download and initialize VirusTotal CLI tool
curl -sL https://api.github.com/repos/VirusTotal/vt-cli/releases/latest | jq -r '.assets[].browser_download_url' | wget -qi -
unzip Linux64.zip
mv vt /usr/bin/
vt init --apikey $virustotal_api_key

## ClamAV scan file
#clamscan -i -v scan_file/$1

# VirusTotal scan file
# Get file list and transfet to file array
file_list=$(ls scan_file)
if $file_list==""; then
	echo "No scan file in folder, exit script"
	exit 0
fi
file_array=(${file_list// / })
for var in ${file_array[@]}
do
	echo $var
	vt scan file scan_file/$var -v > virustotal_preresult.txt
	check=0
	found=0
	while [ $check != 1 ]
	do
		echo "Start to check the scan result of file $var"
		grep $var virustotal_preresult.txt | cut -d " " -f 2 | vt analysis - --include=**.category,status > virustotal_postresult.txt
		if grep -q "completed" virustotal_postresult.txt; then
			echo "Scan is completed"
			if grep -q "Suspicious" virustotal_postresult.txt; then
				echo "Failed!!"
				((found++))
			else
				echo "Passed!!"
			fi
			check=1
		else
			echo "Scan is ongoing, waiting"
			sleep 1m
		fi
		cat virustotal_postresult.txt
	done
done
if $found != 0; then
	echo "0" > result_virustotal.txt
else
	echo "1" > result_virustotal.txt
fi
