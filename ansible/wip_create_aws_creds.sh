#!/usr/bin/env bash

AWS_PATH="/home/ubuntu/.aws/credentials"

if ! [[ -d "/home/ubuntu/.aws" ]]; then
    mkdir /home/ubuntu/.aws
fi

if ! [[ -e "$AWS_PATH" ]]; then
  touch $AWS_PATH
  echo [default] >> $AWS_PATH
  ID="aws_access_key_id = "
  echo $ID$AWS_ACCESS_KEY_ID >> $AWS_PATH
  SECRET="aws_secret_access_key = "
  echo $SECRET$AWS_SECRET_ACCESS_KEY >> $AWS_PATH
fi


#note
if ! [ -f "ssh-key.pem" ]; then echo "NOT PRESENT"; else echo "EXISTS" ;fi