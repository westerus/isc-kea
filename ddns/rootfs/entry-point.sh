#!/bin/sh
set -e
KEACONF=/etc/kea/kea.conf

check_config () {
if [ -f $KEACONF ]; then
  /usr/bin/kea-dhcp-ddns -t $KEACONF
  if [ ! -z $? ]; then
    echo "Error in kea config file $KEACONF"
    exit 1
  fi
fi
}

check_config

exec "$@"
