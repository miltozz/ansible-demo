#!/usr/bin/env bash

#ec2 ubuntu user
sudo apt update
sudo apt upgrade -y
sudo apt install python3-pip -y
python3 -m pip install --user ansible
#  WARNING: The scripts ansible, ansible-config, ansible-connection, ansible-console, ansible-doc, ansible-galaxy, ansible-inventory, ansible-playbook,
#   ansible-pull and ansible-vault are installed in '/home/ubuntu/.local/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#   They are added to PATH by ~/.profile after reboot or relogin
pip3 install boto3
