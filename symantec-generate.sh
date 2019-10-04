#! /bin/bash

# check for two arguments from user
if [ $# -ne 2 ]
  then
    printf "usage: ./symantec-generate.sh <username> <accountName>\n\tAn example of accountName is Fidelity, Google, Amazon, etc.\n"
    exit 1
fi

# check for installed software
if ! [ -x "$(command -v vipaccess)" ]; then
  echo 'Error: vipaccess is not installed. Try "sudo pip3 install python-vipaccess" (or "sudo pip install python-vipaccess" for python 2.7).' >&2
  exit 1
fi

if ! [ -x "$(command -v qrencode)" ]; then
  echo 'Error: qrencode is not installed. Try "sudo apt-get install qrencode".' >&2
  exit 1
fi

# all good! let's do it!
username=$1
account=$2
vipaccess provision -p -t VSMT > vipaccessdata.txt
grep otpauth vipaccessdata.txt | sed -e 's/^[ \t]*//' | sed -e "s/VIP%20Access:VSMT[0-9]*/${username}/" | sed -e "s/issuer=.*/issuer=${account}/" > qrcodeinfo.txt
credential=$(grep -o "this credential: VSMT.*" vipaccessdata.txt | cut -f3 -d' ')
qrencode -o ${credential}.png -s 15 < qrcodeinfo.txt
rm -f vipaccessdata.txt qrcodeinfo.txt
echo "qr code stored in ${credential}.png"