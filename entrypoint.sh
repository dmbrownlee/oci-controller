#!/bin/sh

/bin/chown $IMAGE_UID:$IMAGE_GID /home/$IMAGE_USERNAME/.ssh
/bin/chmod 700 /home/$IMAGE_USERNAME/.ssh

if [ "$1" == "default" ]; then
  if [ ! -x /etc/ssh/ssh_host_ed25519_key ]; then
    /usr/bin/ssh-keygen -A
  fi
  exec /usr/sbin/sshd -D
else
  exec "$@"
fi
