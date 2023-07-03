#!/usr/bin/env bash

#ec2 ubuntu user
sudo apt update
sudo apt upgrade -y
sudo apt install python3-pip -y
python3 -m pip3 install --user ansible
pip3 install boto3
