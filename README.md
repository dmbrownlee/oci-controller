# oci-controller
Container image for OpenTofu and Ansible

This container image is intended for use as a controller host for OpenTofu and Ansible.  Additionally, CLI tools for working with Kubernetes (kubectl, helm) are included.  It is assumed this container will be started locally on the administrators laptop and then accessed via SSH with agent forwarding (SSH keys are assumed to be already added to the ssh-agent running on the laptop hosting the container).  The entrypoint of the container starts sshd by default so you can access a consistent controller host from a variety of remote platforms.

## Usage
Create a `stack.env` file in this directory with values appropriate for your environment.  Copy `stack.env.example` as a starting point.

Use `sudo -i` to switch to the root account, change back to this directory, and then run:
```shell
podman-compose --env-file stack.env up -d
```
Use `ss -ntlp` or similar to confirm the host is listening for incoming SSH connections on the port specified with `HOST_FORWARDING_PORT`.

When the container is created, a user account will be added for your user (see note below), but it will not have a password set and will not be able to run `sudo` within the container.  To fix this, connect a root shell to the running container with:
```shell
podman exec -it controller /bin/bash
```
Once you have a root shell within the container, you can use `passwd` as you would normally to set a password for your user account.  You can also use nvim to edit /etc/suders as you like.

Use an SSH client to connecto the container and forward authentication requests to the local SSH agent.  For example, if you configured the HOST_FORWARDING_PORT to 2222, the openssh client command would be:
```shell
ssh -A -p 2222 localhost
```

If you don't want to use a password to login to the container, use `ssh-copy-id` as you normally would to add your public key to the authorized_keys file.

## Notes
Prior to starting sshd, the container's entrypoint script will run `ansible-pull $ANSIBLE_PULL_OPTIONS` if the `ANSIBLE_PULL_OPTIONS` is set.  This allows you configure the container using an Ansible playbook checked into a remote repository.  For example:

```shell
ANSIBLE_PULL_OPTIONS=-i localhost, -l localhost -U https://github.com/dmbrownlee/pullbook.git -e somevar=somevalue local.yml
```

You will not want to commit sensitive information within your playbook if your playbook is hosted on a publically accessible Git repository.  The entrypoint script will curl the contents of the URL stored in `ANSIBLE_PULL_VARS_FILE_URL` and save it to `/root/ansible-pull.vars` which can then be referenced in your playbook.  However, this assumes the URL containing the variable file is NOT publically accessible.

The use of `ansible-pull` is a convenience.  You may want to skip it and attach a root shell to the container to configure the container manually.
