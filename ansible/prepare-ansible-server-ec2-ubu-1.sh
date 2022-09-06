#!/usr/bin/env bash

# when root
# apt update
# apt install ansible -y
# apt install python3-pip -y
# pip3 install boto3

#ec2 ubuntu user
sudo apt update
sudo apt upgrade -y
sudo apt install python3-pip -y
#  WARNING: The scripts ansible, ansible-config, ansible-connection, ansible-console, ansible-doc, ansible-galaxy, ansible-inventory, ansible-playbook,
#   ansible-pull and ansible-vault are installed in '/home/ubuntu/.local/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
python3 -m pip install --user ansible
pip3 install boto3
