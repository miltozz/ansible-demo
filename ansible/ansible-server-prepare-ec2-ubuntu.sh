#!/usr/bin/env bash

# Install Ansible control node on ec2 as ubuntu user
sudo apt update
sudo apt upgrade -y
sudo apt install python3-pip -y
python3 -m pip install --user ansible
pip install boto3