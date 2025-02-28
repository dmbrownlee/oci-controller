#!/bin/sh

ln -s /usr/bin/tofu /usr/local/bin/terraform

if [ "$1" == "default" ]; then
  if [ ! -x /etc/ssh/ssh_host_ed25519_key ]; then
    /usr/bin/ssh-keygen -A
  fi
  exec /usr/sbin/sshd -D
else
  exec "$@"
fi
