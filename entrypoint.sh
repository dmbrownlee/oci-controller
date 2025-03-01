#!/bin/sh

# If OpenTofu is installed, create terraform symbolic link.
if [ -e /usr/bin/tofu -a ! -e /usr/local/bin/terraform ]; then
  ln -s /usr/bin/tofu /usr/local/bin/terraform
fi

# If ansible is installed and we are passed a playbook repo
# at startup, pull and run it.
if [ -x /usr/bin/ansible-pull -a -n "$ANSIBLE_PULL_OPTIONS" ]; then
  /usr/bin/ansible-pull $ANSIBLE_PULL_OPTIONS
fi

# Run sshd as the first process unless overridden on the CLI.
if [ "$1" = "default" ]; then
  # Generate an SSH host key if it does not exist
  if [ ! -e /etc/ssh/ssh_host_ed25519_key ]; then
    /usr/bin/ssh-keygen -A
  fi

  # Run sshd as the default process
  exec /usr/sbin/sshd -D
else
  # Run user provided command as the entrypoint
  exec "$@"
fi
