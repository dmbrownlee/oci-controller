#!/bin/sh
env > /var/log/entrpoint.env

# If OpenTofu is installed, create terraform symbolic link.
if [ -e /usr/bin/tofu -a ! -e /usr/local/bin/terraform ]; then
  ln -s /usr/bin/tofu /usr/local/bin/terraform
fi

# If ansible is installed and we are passed a playbook repo
# at startup, pull and run it.
if [ -x /usr/bin/ansible-pull -a -n "$ANSIBLE_PULL_OPTIONS" ]; then
  if [ -z "$ANSIBLE_PULL_VARS_FILE_URL" ]; then
    curl -o /root/ansible-pull.vars $ANSIBLE_PULL_VARS_FILE_URL
  fi
  /usr/bin/ansible-pull $ANSIBLE_PULL_OPTIONS 2>/var/log/ansible-pull.stderr >/var/log/ansible-pull.stdout
fi

# Run sshd as the first process unless overridden on the CLI.
if [ "$1" = "default" ]; then
  # Generate an SSH host key if it does not exist
  # Note: /etc/ssh is a mounted volume and may exist from a previous instantiation
  if [ ! -e /etc/ssh/ssh_host_ed25519_key ]; then
    /usr/bin/ssh-keygen -A
  fi

  # Run sshd as the default process
  exec /usr/sbin/sshd -D
else
  # Run user provided command as the entrypoint
  exec "$@"
fi
