#!/bin/bash

DEST='your_dest_server_ssh_name:/var/www/your_domain'

echo $DEST | grep 'your_dest_' > /dev/null && \
	echo "Need fix: update destination before deploy" && exit 2

killall 'gulp serve'
. build.sh

rsync -rlt dist/ "$DEST/"
