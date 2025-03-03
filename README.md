# oci-controller
Container image for OpenTofu and Ansible

This container image is intended as a controller host for OpenTofu and Ansible.  Additionally, CLI tools for working with Kubernetes (kubectl, helm) are included.  The entrypoint of the container starts sshd by default so you can access a consistent controller host from a variety of remote platforms.

Prior to starting sshd, the entrypoint script will run `ansible-pull $ANSIBLE_PULL_OPTIONS` if the `ANSIBLE_PULL_OPTIONS` is set.  This allows you configure the container using an Ansible playbook checked into a remote repository.  For example:

```shell
ANSIBLE_PULL_OPTIONS=-i localhost, -l localhost -U https://github.com/dmbrownlee/pullbook.git -e somevar=somevalue local.yml
```

You will not want to commit sensitive information within your playbook if your playbook is hosted on a publically accessible Git repository.  The entrypoint script will curl the contents of the URL stored in `ANSIBLE_PULL_VARS_FILE_URL` and save it to `/root/ansible-pull.vars` which can then be referenced in your playbook.  However, this assumes the URL containing the variable file is NOT publically accessible.

The use of `ansible-pull` is a convenience.  You may want to skip it and configure the container manually.

The intent of the compose file is to make it easy to deploy this as a stack in Portainer.  When adding a stack in Portainer, you can just point it at the URL for Git repository and it can pull the `docker-compose.yml` file from there.
