#!/bin/sh

if [ "$1" == "default" ]; then
  exec /usr/sbin/sshd -D
else
  exec "$@"
fi
