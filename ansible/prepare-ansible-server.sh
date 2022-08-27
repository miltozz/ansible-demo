#!/usr/bin/env bash

# when root
# apt update
# apt install ansible -y
# apt install python3-pip -y
# pip3 install boto3

#ec2 ubuntu user
sudo apt update
sudo apt upgrade -y
python3 -m pip install --user ansible
pip3 install boto3
