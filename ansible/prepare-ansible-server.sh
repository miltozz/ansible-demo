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
python3 -m pip3 install --user ansible
pip3 install boto3
