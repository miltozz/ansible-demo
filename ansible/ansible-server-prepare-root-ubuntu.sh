#!/usr/bin/env bash

# Install Ansible (control node) as root user on ubuntu
apt update
apt upgrade -y
apt install ansible -y
apt install python3-pip -y
python3 -m pip3 install --user ansible
pip3 install boto3

