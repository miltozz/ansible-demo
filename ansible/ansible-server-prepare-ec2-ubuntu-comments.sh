#!/usr/bin/env bash

# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible
# Install Ansible control node on ec2 as ubuntu user
sudo apt update
sudo apt upgrade -y
sudo apt install python3-pip -y
python3 -m pip install --user ansible
#  Installs as current user
#
#  WARNING: The scripts ansible, ansible-config, ansible-connection, ansible-console, ansible-doc, ansible-galaxy, ansible-inventory, ansible-playbook,
#   ansible-pull and ansible-vault are installed in '/home/ubuntu/.local/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#
#   Note: They are added to PATH (by entry in ~/.profile) after reboot or relogin
pip install boto3
