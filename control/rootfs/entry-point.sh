#!/bin/sh
set -e
KEACONF=/etc/kea/kea-ca.conf

check_config () {
if [ -f $KEACONF ]; then
  /usr/bin/kea-ctrl-agent -t $KEACONF
  if [ ! -z $? ]; then
    echo "Error in kea config file $KEACONF"
    exit 1
  fi
fi
}

check_config

exec "$@"
